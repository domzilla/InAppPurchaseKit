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

// MARK: - IAPSubscriptionRenewalStateTests

@Suite("IAPSubscriptionRenewalState", .tags(.enumMapping, .properties))
struct IAPSubscriptionRenewalStateTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
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

    // MARK: - Init from Product.SubscriptionInfo.RenewalState

    @Suite("init from Product.SubscriptionInfo.RenewalState", .tags(.enumMapping))
    struct InitFromRenewalStateTests {
        @Test("maps subscribed to subscribed")
        func mapsSubscribedToSubscribed() {
            #expect(IAPSubscriptionRenewalState(.subscribed) == .subscribed)
        }

        @Test("maps inGracePeriod to inGracePeriod")
        func mapsInGracePeriodToInGracePeriod() {
            #expect(IAPSubscriptionRenewalState(.inGracePeriod) == .inGracePeriod)
        }

        @Test("maps expired to expired")
        func mapsExpiredToExpired() {
            #expect(IAPSubscriptionRenewalState(.expired) == .expired)
        }

        @Test("maps inBillingRetryPeriod to inBillingRetryPeriod")
        func mapsInBillingRetryPeriodToInBillingRetryPeriod() {
            #expect(IAPSubscriptionRenewalState(.inBillingRetryPeriod) == .inBillingRetryPeriod)
        }

        @Test("maps revoked to revoked")
        func mapsRevokedToRevoked() {
            #expect(IAPSubscriptionRenewalState(.revoked) == .revoked)
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            #expect(IAPSubscriptionRenewalState(nil) == .undefined)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.properties))
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

// MARK: - IAPSubscriptionExpirationReasonTests

@Suite("IAPSubscriptionExpirationReason", .tags(.enumMapping, .properties))
struct IAPSubscriptionExpirationReasonTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
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

    // MARK: - Init from Product.SubscriptionInfo.RenewalInfo.ExpirationReason

    @Suite("init from Product.SubscriptionInfo.RenewalInfo.ExpirationReason", .tags(.enumMapping))
    struct InitFromExpirationReasonTests {
        @Test("maps autoRenewDisabled to autoRenewDisabled")
        func mapsAutoRenewDisabledToAutoRenewDisabled() {
            #expect(IAPSubscriptionExpirationReason(.autoRenewDisabled) == .autoRenewDisabled)
        }

        @Test("maps billingError to billingError")
        func mapsBillingErrorToBillingError() {
            #expect(IAPSubscriptionExpirationReason(.billingError) == .billingError)
        }

        @Test("maps didNotConsentToPriceIncrease to didNotConsentToPriceIncrease")
        func mapsDidNotConsentToPriceIncreaseToDidNotConsentToPriceIncrease() {
            #expect(IAPSubscriptionExpirationReason(.didNotConsentToPriceIncrease) == .didNotConsentToPriceIncrease)
        }

        @Test("maps productUnavailable to productUnavailable")
        func mapsProductUnavailableToProductUnavailable() {
            #expect(IAPSubscriptionExpirationReason(.productUnavailable) == .productUnavailable)
        }

        @Test("maps unknown to unknown")
        func mapsUnknownToUnknown() {
            #expect(IAPSubscriptionExpirationReason(.unknown) == .unknown)
        }

        @Test("maps nil to none")
        func mapsNilToNone() {
            #expect(IAPSubscriptionExpirationReason(nil) == .none)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.properties))
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
