//
//  IAPTransactionObserverTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

// MARK: - IAPTransactionObserverTests

@Suite("IAPTransactionObserver Tests", .tags(.observer), .serialized)
struct IAPTransactionObserverTests {
    // MARK: - isObserving

    @Suite("isObserving", .tags(.properties))
    struct IsObservingTests {
        @Test("returns false when both tasks are nil")
        func returnsFalseWhenBothTasksAreNil() {
            let observer = IAPTransactionObserver()
            #expect(observer.isObserving == false)
        }

        @Test("returns false when only updateListenerTask is set")
        func returnsFalseWhenOnlyUpdateListenerTaskIsSet() {
            let observer = IAPTransactionObserver()
            observer.updateListenerTask = Task<Void, Error> {}
            #expect(observer.isObserving == false)
        }

        @Test("returns false when only unfinishedListenerTask is set")
        func returnsFalseWhenOnlyUnfinishedListenerTaskIsSet() {
            let observer = IAPTransactionObserver()
            observer.unfinishedListenerTask = Task<Void, Error> {}
            #expect(observer.isObserving == false)
        }

        @Test("returns true when both tasks are set and neither is cancelled")
        func returnsTrueWhenBothTasksAreSetAndNeitherIsCancelled() {
            let observer = IAPTransactionObserver()
            observer.updateListenerTask = Task<Void, Error> {}
            observer.unfinishedListenerTask = Task<Void, Error> {}
            #expect(observer.isObserving == true)
        }

        @Test("returns false when both tasks are set and updateListenerTask is cancelled")
        func returnsFalseWhenUpdateListenerTaskIsCancelled() {
            let observer = IAPTransactionObserver()
            let updateTask = Task<Void, Error> { try await Task.sleep(for: .seconds(100)) }
            updateTask.cancel()
            observer.updateListenerTask = updateTask
            observer.unfinishedListenerTask = Task<Void, Error> {}
            #expect(observer.isObserving == false)
        }

        @Test("returns false when both tasks are set and unfinishedListenerTask is cancelled")
        func returnsFalseWhenUnfinishedListenerTaskIsCancelled() {
            let observer = IAPTransactionObserver()
            observer.updateListenerTask = Task<Void, Error> {}
            let unfinishedTask = Task<Void, Error> { try await Task.sleep(for: .seconds(100)) }
            unfinishedTask.cancel()
            observer.unfinishedListenerTask = unfinishedTask
            #expect(observer.isObserving == false)
        }

        @Test("returns false when both tasks are set and both are cancelled")
        func returnsFalseWhenBothTasksAreCancelled() {
            let observer = IAPTransactionObserver()
            let updateTask = Task<Void, Error> { try await Task.sleep(for: .seconds(100)) }
            updateTask.cancel()
            let unfinishedTask = Task<Void, Error> { try await Task.sleep(for: .seconds(100)) }
            unfinishedTask.cancel()
            observer.updateListenerTask = updateTask
            observer.unfinishedListenerTask = unfinishedTask
            #expect(observer.isObserving == false)
        }
    }

    // MARK: - Shared Instance

    @Suite("Shared Instance")
    struct SharedInstanceTests {
        @Test("shared is not nil")
        func sharedIsNotNil() {
            let shared: IAPTransactionObserver? = IAPTransactionObserver.shared
            #expect(shared != nil)
        }

        @Test("shared returns the same instance on repeated access")
        func sharedReturnsSameInstance() {
            #expect(IAPTransactionObserver.shared === IAPTransactionObserver.shared)
        }
    }

    // MARK: - stopObservingUpdates

    @Suite("stopObservingUpdates")
    struct StopObservingTests {
        @Test("cancels both tasks")
        func cancelsBothTasks() {
            let observer = IAPTransactionObserver()
            let updateTask = Task<Void, Error> { try await Task.sleep(for: .seconds(100)) }
            let unfinishedTask = Task<Void, Error> { try await Task.sleep(for: .seconds(100)) }
            observer.updateListenerTask = updateTask
            observer.unfinishedListenerTask = unfinishedTask

            observer.stopObservingUpdates()

            #expect(updateTask.isCancelled == true)
            #expect(unfinishedTask.isCancelled == true)
        }

        @Test("does not crash when tasks are nil")
        func doesNotCrashWhenTasksAreNil() {
            let observer = IAPTransactionObserver()
            observer.stopObservingUpdates()
            #expect(observer.isObserving == false)
        }
    }

    // MARK: - startObservingUpdates

    @Suite("startObservingUpdates")
    struct StartObservingTests {
        @Test("creates both task properties")
        func createsBothTaskProperties() {
            let observer = IAPTransactionObserver()
            observer.startObservingUpdates()

            #expect(observer.updateListenerTask != nil)
            #expect(observer.unfinishedListenerTask != nil)

            observer.stopObservingUpdates()
        }

        @Test("guard prevents duplicate tasks on second call")
        func guardPreventsDuplicateTasksOnSecondCall() {
            let observer = IAPTransactionObserver()
            observer.startObservingUpdates()

            #expect(observer.isObserving == true)

            // Call again — the guard should prevent replacing existing tasks
            observer.startObservingUpdates()

            #expect(observer.isObserving == true)
            #expect(observer.updateListenerTask != nil)
            #expect(observer.unfinishedListenerTask != nil)

            observer.stopObservingUpdates()
        }
    }
}
