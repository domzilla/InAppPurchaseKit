//
//  IAPSubscriptionStatusTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

@Suite("IAPSubscriptionRenewalState")
struct IAPSubscriptionRenewalStateTests {
    // MARK: Raw Values

    @Suite("raw values")
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPSubscriptionRenewalState.undefined, 0),
                (IAPSubscriptionRenewalState.subscribed, 1),
                (IAPSubscriptionRenewalState.inGracePeriod, 2),
                (IAPSubscriptionRenewalState.expired, 3),
                (IAPSubscriptionRenewalState.inBillingRetryPeriod, 4),
                (IAPSubscriptionRenewalState.revoked, 5),
            ]
        )
        func hasExpectedRawValue(_ state: IAPSubscriptionRenewalState, expectedRawValue: Int) {
            #expect(state.rawValue == expectedRawValue)
        }
    }

    // MARK: Init from Product.SubscriptionInfo.RenewalState

    @Suite("init from Product.SubscriptionInfo.RenewalState")
    struct InitFromRenewalStateTests {
        typealias RenewalState = Product.SubscriptionInfo.RenewalState

        @Test(
            "maps StoreKit renewal state to expected case",
            arguments: [
                (RenewalState?.some(.subscribed), IAPSubscriptionRenewalState.subscribed),
                (RenewalState?.some(.inGracePeriod), IAPSubscriptionRenewalState.inGracePeriod),
                (RenewalState?.some(.expired), IAPSubscriptionRenewalState.expired),
                (RenewalState?.some(.inBillingRetryPeriod), IAPSubscriptionRenewalState.inBillingRetryPeriod),
                (RenewalState?.some(.revoked), IAPSubscriptionRenewalState.revoked),
                (RenewalState?.none, IAPSubscriptionRenewalState.undefined),
            ]
        )
        func mapsStoreKitRenewalStateToExpectedCase(
            _ state: RenewalState?,
            expectedState: IAPSubscriptionRenewalState
        ) {
            #expect(IAPSubscriptionRenewalState(state) == expectedState)
        }
    }

    // MARK: Description

    @Suite("description")
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPSubscriptionRenewalState.undefined, "undefined"),
                (IAPSubscriptionRenewalState.subscribed, "subscribed"),
                (IAPSubscriptionRenewalState.inGracePeriod, "inGracePeriod"),
                (IAPSubscriptionRenewalState.expired, "expired"),
                (IAPSubscriptionRenewalState.inBillingRetryPeriod, "inBillingRetryPeriod"),
                (IAPSubscriptionRenewalState.revoked, "revoked"),
            ]
        )
        func returnsExpectedDescriptionString(_ state: IAPSubscriptionRenewalState, expectedDescription: String) {
            #expect(state.description == expectedDescription)
        }
    }
}

@Suite("IAPSubscriptionExpirationReason")
struct IAPSubscriptionExpirationReasonTests {
    // MARK: Raw Values

    @Suite("raw values")
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPSubscriptionExpirationReason.none, 0),
                (IAPSubscriptionExpirationReason.autoRenewDisabled, 1),
                (IAPSubscriptionExpirationReason.billingError, 2),
                (IAPSubscriptionExpirationReason.didNotConsentToPriceIncrease, 3),
                (IAPSubscriptionExpirationReason.productUnavailable, 4),
                (IAPSubscriptionExpirationReason.unknown, 5),
            ]
        )
        func hasExpectedRawValue(_ reason: IAPSubscriptionExpirationReason, expectedRawValue: Int) {
            #expect(reason.rawValue == expectedRawValue)
        }
    }

    // MARK: Init from Product.SubscriptionInfo.RenewalInfo.ExpirationReason

    @Suite("init from Product.SubscriptionInfo.RenewalInfo.ExpirationReason")
    struct InitFromExpirationReasonTests {
        typealias ExpirationReason = Product.SubscriptionInfo.RenewalInfo.ExpirationReason

        @Test(
            "maps StoreKit expiration reason to expected case",
            arguments: [
                (ExpirationReason?.some(.autoRenewDisabled), IAPSubscriptionExpirationReason.autoRenewDisabled),
                (ExpirationReason?.some(.billingError), IAPSubscriptionExpirationReason.billingError),
                (
                    ExpirationReason?.some(.didNotConsentToPriceIncrease),
                    IAPSubscriptionExpirationReason.didNotConsentToPriceIncrease
                ),
                (ExpirationReason?.some(.productUnavailable), IAPSubscriptionExpirationReason.productUnavailable),
                (ExpirationReason?.some(.unknown), IAPSubscriptionExpirationReason.unknown),
                (ExpirationReason?.none, IAPSubscriptionExpirationReason.none),
            ]
        )
        func mapsStoreKitExpirationReasonToExpectedCase(
            _ reason: ExpirationReason?,
            expectedReason: IAPSubscriptionExpirationReason
        ) {
            #expect(IAPSubscriptionExpirationReason(reason) == expectedReason)
        }
    }

    // MARK: Description

    @Suite("description")
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPSubscriptionExpirationReason.none, "none"),
                (IAPSubscriptionExpirationReason.autoRenewDisabled, "autoRenewDisabled"),
                (IAPSubscriptionExpirationReason.billingError, "billingError"),
                (IAPSubscriptionExpirationReason.didNotConsentToPriceIncrease, "didNotConsentToPriceIncrease"),
                (IAPSubscriptionExpirationReason.productUnavailable, "productUnavailable"),
                (IAPSubscriptionExpirationReason.unknown, "unknown"),
            ]
        )
        func returnsExpectedDescriptionString(_ reason: IAPSubscriptionExpirationReason, expectedDescription: String) {
            #expect(reason.description == expectedDescription)
        }
    }
}
