//
//  IAPTransactionTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

// MARK: - IAPTransactionOwnershipTypeTests

@Suite("IAPTransactionOwnershipType", .tags(.enumMapping, .properties))
struct IAPTransactionOwnershipTypeTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPTransactionOwnershipType.undefined, 0),
                (IAPTransactionOwnershipType.familyShared, 1),
                (IAPTransactionOwnershipType.purchased, 2),
            ]
        )
        func hasExpectedRawValue(_ ownershipType: IAPTransactionOwnershipType, expectedRawValue: Int) {
            #expect(ownershipType.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from Transaction.OwnershipType

    @Suite("init from Transaction.OwnershipType", .tags(.enumMapping))
    struct InitFromOwnershipTypeTests {
        @Test("maps familyShared to familyShared")
        func mapsFamilySharedToFamilyShared() {
            #expect(IAPTransactionOwnershipType(.familyShared) == .familyShared)
        }

        @Test("maps purchased to purchased")
        func mapsPurchasedToPurchased() {
            #expect(IAPTransactionOwnershipType(.purchased) == .purchased)
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            let ownershipType: Transaction.OwnershipType? = nil
            #expect(IAPTransactionOwnershipType(ownershipType) == .undefined)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPTransactionOwnershipType.undefined, "undefined"),
                (IAPTransactionOwnershipType.familyShared, "familyShared"),
                (IAPTransactionOwnershipType.purchased, "purchased"),
            ]
        )
        func returnsExpectedDescriptionString(
            _ ownershipType: IAPTransactionOwnershipType,
            expectedDescription: String
        ) {
            #expect(ownershipType.description == expectedDescription)
        }
    }
}

// MARK: - IAPTransactionReasonTests

@Suite("IAPTransactionReason", .tags(.enumMapping, .properties))
struct IAPTransactionReasonTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPTransactionReason.undefined, 0),
                (IAPTransactionReason.purchase, 1),
                (IAPTransactionReason.renewal, 2),
            ]
        )
        func hasExpectedRawValue(_ reason: IAPTransactionReason, expectedRawValue: Int) {
            #expect(reason.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from String

    @Suite("init from String", .tags(.stringParsing))
    struct InitFromStringTests {
        @Test(
            "maps string to expected transaction reason",
            arguments: [
                ("purchase", IAPTransactionReason.purchase),
                ("renewal", IAPTransactionReason.renewal),
                ("PURCHASE", IAPTransactionReason.purchase),
                ("Renewal", IAPTransactionReason.renewal),
                ("unknown", IAPTransactionReason.undefined),
                ("", IAPTransactionReason.undefined),
            ]
        )
        func mapsStringToExpectedTransactionReason(_ input: String, expectedReason: IAPTransactionReason) {
            #expect(IAPTransactionReason(input) == expectedReason)
        }
    }

    // MARK: - Init from Transaction.Reason

    @Suite("init from Transaction.Reason", .tags(.enumMapping))
    struct InitFromTransactionReasonTests {
        @Test("maps purchase to purchase")
        func mapsPurchaseToPurchase() {
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                #expect(IAPTransactionReason(.purchase) == .purchase)
            }
        }

        @Test("maps renewal to renewal")
        func mapsRenewalToRenewal() {
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                #expect(IAPTransactionReason(.renewal) == .renewal)
            }
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                let reason: Transaction.Reason? = nil
                #expect(IAPTransactionReason(reason) == .undefined)
            }
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPTransactionReason.undefined, "undefined"),
                (IAPTransactionReason.purchase, "purchase"),
                (IAPTransactionReason.renewal, "renewal"),
            ]
        )
        func returnsExpectedDescriptionString(_ reason: IAPTransactionReason, expectedDescription: String) {
            #expect(reason.description == expectedDescription)
        }
    }
}

// MARK: - IAPRevocationReasonTests

@Suite("IAPRevocationReason", .tags(.enumMapping, .properties))
struct IAPRevocationReasonTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPRevocationReason.undefined, 0),
                (IAPRevocationReason.developerIssue, 1),
                (IAPRevocationReason.other, 2),
            ]
        )
        func hasExpectedRawValue(_ revocationReason: IAPRevocationReason, expectedRawValue: Int) {
            #expect(revocationReason.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from Transaction.RevocationReason

    @Suite("init from Transaction.RevocationReason", .tags(.enumMapping))
    struct InitFromRevocationReasonTests {
        @Test("maps developerIssue to developerIssue")
        func mapsDeveloperIssueToDeveloperIssue() {
            #expect(IAPRevocationReason(.developerIssue) == .developerIssue)
        }

        @Test("maps other to other")
        func mapsOtherToOther() {
            #expect(IAPRevocationReason(.other) == .other)
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            let revocationReason: Transaction.RevocationReason? = nil
            #expect(IAPRevocationReason(revocationReason) == .undefined)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPRevocationReason.undefined, "undefined"),
                (IAPRevocationReason.developerIssue, "developerIssue"),
                (IAPRevocationReason.other, "other"),
            ]
        )
        func returnsExpectedDescriptionString(_ revocationReason: IAPRevocationReason, expectedDescription: String) {
            #expect(revocationReason.description == expectedDescription)
        }
    }
}

// MARK: - IAPRefundRequestStatusTests

@Suite("IAPRefundRequestStatus", .tags(.enumMapping, .properties))
struct IAPRefundRequestStatusTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPRefundRequestStatus.undefined, 0),
                (IAPRefundRequestStatus.userCanceled, 1),
                (IAPRefundRequestStatus.success, 2),
            ]
        )
        func hasExpectedRawValue(_ status: IAPRefundRequestStatus, expectedRawValue: Int) {
            #expect(status.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from Transaction.RefundRequestStatus

    @Suite("init from Transaction.RefundRequestStatus", .tags(.enumMapping))
    struct InitFromRefundRequestStatusTests {
        // NOTE: StoreKit spells the case .userCancelled (double-l); the IAP wrapper
        // maps it to .userCanceled (single-l) to match Cocoa naming conventions.

        @Test("maps userCancelled to userCanceled")
        func mapsUserCancelledToUserCanceled() {
            #expect(IAPRefundRequestStatus(.userCancelled) == .userCanceled)
        }

        @Test("maps success to success")
        func mapsSuccessToSuccess() {
            #expect(IAPRefundRequestStatus(.success) == .success)
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            let status: Transaction.RefundRequestStatus? = nil
            #expect(IAPRefundRequestStatus(status) == .undefined)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPRefundRequestStatus.undefined, "undefined"),
                (IAPRefundRequestStatus.userCanceled, "userCanceled"),
                (IAPRefundRequestStatus.success, "success"),
            ]
        )
        func returnsExpectedDescriptionString(_ status: IAPRefundRequestStatus, expectedDescription: String) {
            #expect(status.description == expectedDescription)
        }
    }
}

// MARK: - IAPTransactionNotificationTests

@Suite("IAPTransaction notifications", .tags(.properties))
struct IAPTransactionNotificationTests {
    @Test("TransactionDidFinishNotification has expected name string")
    func transactionDidFinishNotificationHasExpectedNameString() {
        #expect(IAPTransaction.TransactionDidFinishNotification.rawValue == "IAPTransactionDidFinishNotification")
    }
}
