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

@Suite("IAPTransactionOwnershipType")
struct IAPTransactionOwnershipTypeTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from Transaction.OwnershipType

    @Suite("init from Transaction.OwnershipType")
    struct InitFromOwnershipTypeTests {
        @Test(
            "maps StoreKit ownership type to expected case",
            arguments: [
                (Transaction.OwnershipType?.some(.familyShared), IAPTransactionOwnershipType.familyShared),
                (Transaction.OwnershipType?.some(.purchased), IAPTransactionOwnershipType.purchased),
                (Transaction.OwnershipType?.none, IAPTransactionOwnershipType.undefined),
            ]
        )
        func mapsStoreKitOwnershipTypeToExpectedCase(
            _ ownershipType: Transaction.OwnershipType?,
            expectedOwnershipType: IAPTransactionOwnershipType
        ) {
            #expect(IAPTransactionOwnershipType(ownershipType) == expectedOwnershipType)
        }
    }

    // MARK: Description

    @Suite("description")
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

@Suite("IAPTransactionReason")
struct IAPTransactionReasonTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from String

    @Suite("init from String")
    struct InitFromStringTests {
        @Test(
            "maps string case-insensitively to expected transaction reason",
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

    // MARK: Init from Transaction.Reason

    @Suite("init from Transaction.Reason")
    struct InitFromTransactionReasonTests {
        @Test(
            "maps StoreKit reason to expected case",
            arguments: [
                (Transaction.Reason?.some(.purchase), IAPTransactionReason.purchase),
                (Transaction.Reason?.some(.renewal), IAPTransactionReason.renewal),
                (Transaction.Reason?.none, IAPTransactionReason.undefined),
            ]
        )
        func mapsStoreKitReasonToExpectedCase(_ reason: Transaction.Reason?, expectedReason: IAPTransactionReason) {
            #expect(IAPTransactionReason(reason) == expectedReason)
        }
    }

    // MARK: Description

    @Suite("description")
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

        @Test(
            "LosslessStringConvertible round-trip produces the same case",
            arguments: [IAPTransactionReason.undefined, IAPTransactionReason.purchase, IAPTransactionReason.renewal]
        )
        func roundTripProducesSameCase(_ reason: IAPTransactionReason) {
            #expect(IAPTransactionReason(reason.description) == reason)
        }
    }
}

@Suite("IAPRevocationReason")
struct IAPRevocationReasonTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from Transaction.RevocationReason

    @Suite("init from Transaction.RevocationReason")
    struct InitFromRevocationReasonTests {
        @Test(
            "maps StoreKit revocation reason to expected case",
            arguments: [
                (Transaction.RevocationReason?.some(.developerIssue), IAPRevocationReason.developerIssue),
                (Transaction.RevocationReason?.some(.other), IAPRevocationReason.other),
                (Transaction.RevocationReason?.none, IAPRevocationReason.undefined),
            ]
        )
        func mapsStoreKitRevocationReasonToExpectedCase(
            _ revocationReason: Transaction.RevocationReason?,
            expectedRevocationReason: IAPRevocationReason
        ) {
            #expect(IAPRevocationReason(revocationReason) == expectedRevocationReason)
        }
    }

    // MARK: Description

    @Suite("description")
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

@Suite("IAPRefundRequestStatus")
struct IAPRefundRequestStatusTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from Transaction.RefundRequestStatus

    @Suite("init from Transaction.RefundRequestStatus")
    struct InitFromRefundRequestStatusTests {
        @Test(
            "maps StoreKit refund request status to expected case",
            arguments: [
                (Transaction.RefundRequestStatus?.some(.userCancelled), IAPRefundRequestStatus.userCanceled),
                (Transaction.RefundRequestStatus?.some(.success), IAPRefundRequestStatus.success),
                (Transaction.RefundRequestStatus?.none, IAPRefundRequestStatus.undefined),
            ]
        )
        func mapsStoreKitRefundRequestStatusToExpectedCase(
            _ status: Transaction.RefundRequestStatus?,
            expectedStatus: IAPRefundRequestStatus
        ) {
            #expect(IAPRefundRequestStatus(status) == expectedStatus)
        }
    }

    // MARK: Description

    @Suite("description")
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
