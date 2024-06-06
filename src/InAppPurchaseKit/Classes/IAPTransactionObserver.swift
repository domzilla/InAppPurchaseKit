//
//  IAPTransactionObserver.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

@objc public class IAPTransactionObserver : NSObject {
    
    var updateListenerTask: Task<Void, Error>? = nil
    var unfinishedListenerTask: Task<Void, Error>? = nil
    
    // MARK: Public Properties
    // MARK: --
    
    @objc public static let shared = IAPTransactionObserver()
    
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
    // MARK: --
    
    @objc public func startObservingUpdates () {
        
        if self.isObserving {
            return
        }
        
        self.updateListenerTask = Task.detached {
            //Iterate through any transactions that don't come from a direct call to 'purchase()'.
            for await result in Transaction.updates {
                await self.process(verificationResult: result)
            }
        }
        
        self.unfinishedListenerTask = Task.detached {
            //Iterate through any unfinished transactions
            for await result in Transaction.unfinished {
                await self.process(verificationResult: result)
            }
        }
    }
    
    @objc public func stopObservingUpdates () {
        
        self.updateListenerTask?.cancel()
        self.unfinishedListenerTask?.cancel()
    }
        
    // MARK: Private
    // MARK: --
    
    private func process(verificationResult: VerificationResult<Transaction>) async {
        
        guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
            return
        }
        //Always finish a transaction.
        await transaction.finish()
    }
}
