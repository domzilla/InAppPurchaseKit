//
//  IAPErrorTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

// MARK: - IAPErrorTests

@Suite("IAPError", .tags(.errorHandling))
struct IAPErrorTests {
    // MARK: - IAPErrorCode Raw Values

    @Suite("IAPErrorCode raw values", .tags(.enumMapping, .properties))
    struct IAPErrorCodeRawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPErrorCode.unknown, 0),
                (IAPErrorCode.networkError, 1),
                (IAPErrorCode.systemError, 2),
                (IAPErrorCode.userCancelled, 3),
                (IAPErrorCode.notAvailableInStorefront, 4),
                (IAPErrorCode.notEntitled, 5),
            ]
        )
        func hasExpectedRawValue(_ errorCode: IAPErrorCode, expectedRawValue: Int) {
            #expect(errorCode.rawValue == expectedRawValue)
        }
    }

    // MARK: - errorCodeFromStoreKitError Mapping

    @Suite("errorCodeFromStoreKitError()", .tags(.errorHandling, .enumMapping))
    struct ErrorCodeMappingTests {
        @Test("returns unknown for nil error")
        func returnsUnknownForNilError() {
            let result = IAPError.errorCodeFromStoreKitError(error: nil)
            #expect(result == .unknown)
        }

        @Test("returns unknown for non-StoreKit error")
        func returnsUnknownForNonStoreKitError() {
            let error = NSError(domain: "test", code: 0)
            let result = IAPError.errorCodeFromStoreKitError(error: error)
            #expect(result == .unknown)
        }

        @Test("maps networkError to networkError code")
        func mapsNetworkErrorToNetworkErrorCode() {
            let underlyingError = URLError(.notConnectedToInternet)
            let storeKitError = StoreKitError.networkError(underlyingError)
            let result = IAPError.errorCodeFromStoreKitError(error: storeKitError)
            #expect(result == .networkError)
        }

        @Test("maps systemError to systemError code")
        func mapsSystemErrorToSystemErrorCode() {
            let underlyingError = NSError(domain: "test", code: 0)
            let storeKitError = StoreKitError.systemError(underlyingError)
            let result = IAPError.errorCodeFromStoreKitError(error: storeKitError)
            #expect(result == .systemError)
        }

        @Test("maps userCancelled to userCancelled code")
        func mapsUserCancelledToUserCancelledCode() {
            let result = IAPError.errorCodeFromStoreKitError(error: StoreKitError.userCancelled)
            #expect(result == .userCancelled)
        }

        @Test("maps notAvailableInStorefront to notAvailableInStorefront code")
        func mapsNotAvailableInStorefrontToNotAvailableInStorefrontCode() {
            let result = IAPError.errorCodeFromStoreKitError(error: StoreKitError.notAvailableInStorefront)
            #expect(result == .notAvailableInStorefront)
        }

        @Test("maps notEntitled to notEntitled code")
        func mapsNotEntitledToNotEntitledCode() {
            let result = IAPError.errorCodeFromStoreKitError(error: StoreKitError.notEntitled)
            #expect(result == .notEntitled)
        }
    }
}
