//
//  IAPTransactionObserver.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

/// An observer that monitors StoreKit2 transaction updates and processes unfinished transactions in the background.
///
/// `IAPTransactionObserver` listens for transactions that arrive outside of a direct call to `purchase()`,
/// such as subscription renewals, family sharing events, and purchases made on other devices. It also
/// processes any unfinished transactions that were not completed in a previous app session.
///
/// Use the ``shared`` singleton instance and call ``startObservingUpdates()`` early in your app's lifecycle
/// (typically at launch) to ensure transactions are handled promptly.
///
/// - Note: Uses `Transaction.updates` and `Transaction.unfinished` from StoreKit2. All verified
///   transactions are automatically finished via ``IAPTransaction/finish()``, which also posts
///   `IAPTransaction.TransactionDidFinishNotification`.
@objc
public class IAPTransactionObserver: NSObject {
    var updateListenerTask: Task<Void, Error>?

    var unfinishedListenerTask: Task<Void, Error>?

    // MARK: Public Properties

    // MARK: - -

    /// The shared singleton instance of the transaction observer.
    ///
    /// Use this instance to start and stop observing transaction updates across the app.
    @objc public static let shared = IAPTransactionObserver()

    /// A Boolean value indicating whether the observer is currently listening for transaction updates.
    ///
    /// Returns `true` when the `Transaction.updates` listener task has been started and not cancelled.
    /// Returns `false` if it is `nil` or has been cancelled. The `Transaction.unfinished` listener is
    /// a finite task that completes on its own, so it does not affect this value.
    @objc public var isObserving: Bool {
        guard let updatesTask = self.updateListenerTask else {
            return false
        }
        return !updatesTask.isCancelled
    }

    // MARK: Public

    // MARK: - -

    /// Starts observing transaction updates and processing unfinished transactions.
    ///
    /// This method launches two detached background tasks:
    /// 1. A listener on `Transaction.updates` that processes transactions arriving outside of a direct
    ///    `purchase()` call (e.g., subscription renewals, family sharing events, Ask to Buy approvals).
    /// 2. A listener on `Transaction.unfinished` that processes any transactions left unfinished from
    ///    previous app sessions.
    ///
    /// If the observer is already active (``isObserving`` is `true`), this method returns immediately
    /// without creating duplicate tasks.
    ///
    /// - Note: Call this method early in your app's lifecycle, ideally during app launch, to ensure
    ///   no transactions are missed.
    @objc
    public func startObservingUpdates() {
        if self.isObserving {
            return
        }

        self.updateListenerTask = Task.detached {
            // Iterate through any transactions that don't come from a direct call to 'purchase()'.
            for await result in Transaction.updates {
                await self.process(verificationResult: result)
            }
        }

        self.unfinishedListenerTask = Task.detached {
            // Iterate through any unfinished transactions
            for await result in Transaction.unfinished {
                await self.process(verificationResult: result)
            }
        }
    }

    /// Stops observing transaction updates by cancelling both background listener tasks.
    ///
    /// After calling this method, ``isObserving`` will return `false`. You can resume observing
    /// by calling ``startObservingUpdates()`` again.
    @objc
    public func stopObservingUpdates() {
        self.updateListenerTask?.cancel()
        self.unfinishedListenerTask?.cancel()
    }

    // MARK: Private

    // MARK: - -

    private func process(verificationResult: VerificationResult<Transaction>) async {
        guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
            return
        }
        // Always finish a transaction.
        await transaction.finish()
    }
}
