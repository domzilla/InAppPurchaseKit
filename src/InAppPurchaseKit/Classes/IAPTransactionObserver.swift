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
    /// The background task that listens for new transaction updates via `Transaction.updates`.
    var updateListenerTask: Task<Void, Error>?

    /// The background task that iterates through unfinished transactions via `Transaction.unfinished`.
    var unfinishedListenerTask: Task<Void, Error>?

    // MARK: Public Properties

    // MARK: - -

    /// The shared singleton instance of the transaction observer.
    ///
    /// Use this instance to start and stop observing transaction updates across the app.
    @objc public static let shared = IAPTransactionObserver()

    /// A Boolean value indicating whether the observer is currently listening for transaction updates.
    ///
    /// Returns `true` when both the update listener task and the unfinished listener task are active
    /// and have not been cancelled. Returns `false` if either task is `nil` or has been cancelled.
    @objc public var isObserving: Bool {
        guard let updatesTask = self.updateListenerTask else {
            return false
        }
        guard let unfinishedTask = self.unfinishedListenerTask else {
            return false
        }
        return !updatesTask.isCancelled && !unfinishedTask.isCancelled
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

    /// Processes a single transaction verification result by verifying and finishing the transaction.
    ///
    /// Only verified transactions are processed. Unverified transactions are silently discarded
    /// (with debug output logged by ``IAPTransaction/transaction(fromVerificationResult:)``).
    /// Verified transactions are immediately finished, which also posts
    /// `IAPTransaction.TransactionDidFinishNotification`.
    ///
    /// - Parameter verificationResult: The `VerificationResult<Transaction>` to process.
    private func process(verificationResult: VerificationResult<Transaction>) async {
        guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
            return
        }
        // Always finish a transaction.
        await transaction.finish()
    }
}
