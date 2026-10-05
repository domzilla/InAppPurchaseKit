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

@Suite("IAPError")
struct IAPErrorTests {
    // MARK: IAPErrorCode Raw Values

    @Suite("IAPErrorCode raw values")
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

    // MARK: errorCodeFromStoreKitError Mapping

    @Suite("errorCodeFromStoreKitError(error:)")
    struct ErrorCodeMappingTests {
        @Test("returns unknown for nil error")
        func returnsUnknownForNilError() {
            #expect(IAPError.errorCodeFromStoreKitError(error: nil) == .unknown)
        }

        @Test("returns unknown for non-StoreKit error")
        func returnsUnknownForNonStoreKitError() {
            let error = URLError(.notConnectedToInternet)
            #expect(IAPError.errorCodeFromStoreKitError(error: error) == .unknown)
        }

        @Test(
            "maps StoreKitError to expected code",
            arguments: [
                (StoreKitError.networkError(URLError(.notConnectedToInternet)), IAPErrorCode.networkError),
                (StoreKitError.systemError(URLError(.unknown)), IAPErrorCode.systemError),
                (StoreKitError.userCancelled, IAPErrorCode.userCancelled),
                (StoreKitError.notAvailableInStorefront, IAPErrorCode.notAvailableInStorefront),
                (StoreKitError.notEntitled, IAPErrorCode.notEntitled),
                (StoreKitError.unknown, IAPErrorCode.unknown),
            ]
        )
        func mapsStoreKitErrorToExpectedCode(_ storeKitError: StoreKitError, expectedErrorCode: IAPErrorCode) {
            #expect(IAPError.errorCodeFromStoreKitError(error: storeKitError) == expectedErrorCode)
        }
    }
}
