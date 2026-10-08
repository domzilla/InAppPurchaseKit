//
//  IAPTransactionObserverTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import Testing
@testable import InAppPurchaseKit

@Suite("IAPTransactionObserver", .serialized)
struct IAPTransactionObserverTests {
    /// Stays running until cancelled, so `isCancelled` reflects only an explicit `cancel()`.
    static func makePendingTask() -> Task<Void, Error> {
        Task {
            try await Task.sleep(for: .seconds(3600))
        }
    }

    // MARK: isObserving

    @Suite("isObserving")
    struct IsObservingTests {
        @Test("returns false when both tasks are nil")
        func returnsFalseWhenBothTasksAreNil() {
            let observer = IAPTransactionObserver()
            #expect(observer.isObserving == false)
        }

        @Test("returns true when only updateListenerTask is set")
        func returnsTrueWhenOnlyUpdateListenerTaskIsSet() {
            let observer = IAPTransactionObserver()
            observer.updateListenerTask = IAPTransactionObserverTests.makePendingTask()
            #expect(observer.isObserving == true)
            observer.stopObservingUpdates()
        }

        @Test("returns false when only unfinishedListenerTask is set")
        func returnsFalseWhenOnlyUnfinishedListenerTaskIsSet() {
            let observer = IAPTransactionObserver()
            observer.unfinishedListenerTask = IAPTransactionObserverTests.makePendingTask()
            #expect(observer.isObserving == false)
            observer.stopObservingUpdates()
        }

        @Test("returns true when both tasks are set and neither is cancelled")
        func returnsTrueWhenBothTasksAreSetAndNeitherIsCancelled() {
            let observer = IAPTransactionObserver()
            observer.updateListenerTask = IAPTransactionObserverTests.makePendingTask()
            observer.unfinishedListenerTask = IAPTransactionObserverTests.makePendingTask()
            #expect(observer.isObserving == true)
            observer.stopObservingUpdates()
        }

        @Test("returns false when updateListenerTask is cancelled", arguments: [false, true])
        func returnsFalseWhenUpdateTaskIsCancelled(isUnfinishedTaskCancelled: Bool) {
            let observer = IAPTransactionObserver()
            let updateTask = IAPTransactionObserverTests.makePendingTask()
            let unfinishedTask = IAPTransactionObserverTests.makePendingTask()
            observer.updateListenerTask = updateTask
            observer.unfinishedListenerTask = unfinishedTask

            updateTask.cancel()
            if isUnfinishedTaskCancelled {
                unfinishedTask.cancel()
            }

            #expect(observer.isObserving == false)
            observer.stopObservingUpdates()
        }

        @Test("returns true when only unfinishedListenerTask is cancelled")
        func returnsTrueWhenOnlyUnfinishedTaskIsCancelled() {
            let observer = IAPTransactionObserver()
            let unfinishedTask = IAPTransactionObserverTests.makePendingTask()
            observer.updateListenerTask = IAPTransactionObserverTests.makePendingTask()
            observer.unfinishedListenerTask = unfinishedTask

            unfinishedTask.cancel()

            #expect(observer.isObserving == true)
            observer.stopObservingUpdates()
        }

        @Test("returns true after unfinishedListenerTask completes")
        func returnsTrueAfterUnfinishedTaskCompletes() async {
            let observer = IAPTransactionObserver()
            let unfinishedTask = Task<Void, Error> {}
            observer.updateListenerTask = IAPTransactionObserverTests.makePendingTask()
            observer.unfinishedListenerTask = unfinishedTask

            _ = await unfinishedTask.result

            #expect(observer.isObserving == true)
            observer.stopObservingUpdates()
        }
    }

    // MARK: stopObservingUpdates

    @Suite("stopObservingUpdates")
    struct StopObservingTests {
        @Test("cancels both tasks")
        func cancelsBothTasks() {
            let observer = IAPTransactionObserver()
            let updateTask = IAPTransactionObserverTests.makePendingTask()
            let unfinishedTask = IAPTransactionObserverTests.makePendingTask()
            observer.updateListenerTask = updateTask
            observer.unfinishedListenerTask = unfinishedTask

            observer.stopObservingUpdates()

            #expect(updateTask.isCancelled == true)
            #expect(unfinishedTask.isCancelled == true)
            #expect(observer.isObserving == false)
        }
    }

    // MARK: startObservingUpdates

    @Suite("startObservingUpdates")
    struct StartObservingTests {
        @Test("starts observing")
        func startsObserving() {
            let observer = IAPTransactionObserver()

            observer.startObservingUpdates()

            #expect(observer.isObserving == true)
            observer.stopObservingUpdates()
        }

        @Test("keeps the existing tasks on a second call")
        func keepsExistingTasksOnSecondCall() throws {
            let observer = IAPTransactionObserver()
            observer.startObservingUpdates()
            let updateTask = try #require(observer.updateListenerTask)
            let unfinishedTask = try #require(observer.unfinishedListenerTask)

            observer.startObservingUpdates()

            #expect(observer.updateListenerTask == updateTask)
            #expect(observer.unfinishedListenerTask == unfinishedTask)
            observer.stopObservingUpdates()
        }

        @Test("starts new tasks after stopObservingUpdates")
        func startsNewTasksAfterStop() throws {
            let observer = IAPTransactionObserver()
            observer.startObservingUpdates()
            let updateTask = try #require(observer.updateListenerTask)
            observer.stopObservingUpdates()

            observer.startObservingUpdates()

            #expect(observer.isObserving == true)
            #expect(observer.updateListenerTask != updateTask)
            observer.stopObservingUpdates()
        }
    }
}
