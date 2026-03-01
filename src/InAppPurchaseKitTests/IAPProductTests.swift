//
//  IAPProductTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

// MARK: - IAPProductTypeTests

@Suite("IAPProductType", .tags(.enumMapping, .properties))
struct IAPProductTypeTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPProductType.undefined, 0),
                (IAPProductType.consumable, 1),
                (IAPProductType.nonConsumable, 2),
                (IAPProductType.nonRenewable, 3),
                (IAPProductType.autoRenewable, 4),
            ]
        )
        func hasExpectedRawValue(_ productType: IAPProductType, expectedRawValue: Int) {
            #expect(productType.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from Product.ProductType

    @Suite("init from Product.ProductType", .tags(.enumMapping))
    struct InitFromProductTypeTests {
        @Test("maps consumable to consumable")
        func mapsConsumableToConsumable() {
            #expect(IAPProductType(.consumable) == .consumable)
        }

        @Test("maps nonConsumable to nonConsumable")
        func mapsNonConsumableToNonConsumable() {
            #expect(IAPProductType(.nonConsumable) == .nonConsumable)
        }

        @Test("maps nonRenewable to nonRenewable")
        func mapsNonRenewableToNonRenewable() {
            #expect(IAPProductType(.nonRenewable) == .nonRenewable)
        }

        @Test("maps autoRenewable to autoRenewable")
        func mapsAutoRenewableToAutoRenewable() {
            #expect(IAPProductType(.autoRenewable) == .autoRenewable)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPProductType.undefined, "undefined"),
                (IAPProductType.consumable, "consumable"),
                (IAPProductType.nonConsumable, "nonConsumable"),
                (IAPProductType.nonRenewable, "nonRenewable"),
                (IAPProductType.autoRenewable, "autoRenewable"),
            ]
        )
        func returnsExpectedDescriptionString(_ productType: IAPProductType, expectedDescription: String) {
            #expect(productType.description == expectedDescription)
        }
    }
}

// MARK: - IAPPaymentModeTests

@Suite("IAPPaymentMode", .tags(.enumMapping, .properties))
struct IAPPaymentModeTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPPaymentMode.undefined, 0),
                (IAPPaymentMode.freeTrial, 1),
                (IAPPaymentMode.payAsYouGo, 2),
                (IAPPaymentMode.payUpFront, 3),
            ]
        )
        func hasExpectedRawValue(_ paymentMode: IAPPaymentMode, expectedRawValue: Int) {
            #expect(paymentMode.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from String

    @Suite("init from String", .tags(.stringParsing))
    struct InitFromStringTests {
        @Test(
            "maps valid lowercase string to expected payment mode",
            arguments: [
                ("free_trial", IAPPaymentMode.freeTrial),
                ("pay_as_you_go", IAPPaymentMode.payAsYouGo),
                ("pay_up_front", IAPPaymentMode.payUpFront),
            ]
        )
        func mapsValidStringToExpectedPaymentMode(_ input: String, expectedMode: IAPPaymentMode) {
            #expect(IAPPaymentMode(input) == expectedMode)
        }

        @Test("maps uppercased FREE_TRIAL to freeTrial")
        func mapsUppercasedFreeTrialToFreeTrial() {
            #expect(IAPPaymentMode("FREE_TRIAL") == .freeTrial)
        }

        @Test("maps mixed-case Free_Trial to freeTrial")
        func mapsMixedCaseFreeTrialToFreeTrial() {
            #expect(IAPPaymentMode("Free_Trial") == .freeTrial)
        }

        @Test("maps uppercased PAY_AS_YOU_GO to payAsYouGo")
        func mapsUppercasedPayAsYouGoToPayAsYouGo() {
            #expect(IAPPaymentMode("PAY_AS_YOU_GO") == .payAsYouGo)
        }

        @Test("maps uppercased PAY_UP_FRONT to payUpFront")
        func mapsUppercasedPayUpFrontToPayUpFront() {
            #expect(IAPPaymentMode("PAY_UP_FRONT") == .payUpFront)
        }

        @Test(
            "maps invalid string to undefined",
            arguments: ["", "unknown", "freeTrialX", "free trial", "payasYouGo"]
        )
        func mapsInvalidStringToUndefined(_ input: String) {
            #expect(IAPPaymentMode(input) == .undefined)
        }
    }

    // MARK: - Init from Product.SubscriptionOffer.PaymentMode

    @Suite("init from Product.SubscriptionOffer.PaymentMode", .tags(.enumMapping))
    struct InitFromSubscriptionOfferPaymentModeTests {
        @Test("maps freeTrial to freeTrial")
        func mapsFreeTrialToFreeTrial() {
            #expect(IAPPaymentMode(Product.SubscriptionOffer.PaymentMode.freeTrial) == .freeTrial)
        }

        @Test("maps payAsYouGo to payAsYouGo")
        func mapsPayAsYouGoToPayAsYouGo() {
            #expect(IAPPaymentMode(Product.SubscriptionOffer.PaymentMode.payAsYouGo) == .payAsYouGo)
        }

        @Test("maps payUpFront to payUpFront")
        func mapsPayUpFrontToPayUpFront() {
            #expect(IAPPaymentMode(Product.SubscriptionOffer.PaymentMode.payUpFront) == .payUpFront)
        }
    }

    // MARK: - Init from Transaction.Offer.PaymentMode

    @Suite("init from Transaction.Offer.PaymentMode", .tags(.enumMapping))
    struct InitFromTransactionOfferPaymentModeTests {
        @Test("maps freeTrial to freeTrial")
        func mapsFreeTrialToFreeTrial() {
            if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *) {
                #expect(IAPPaymentMode(Transaction.Offer.PaymentMode.freeTrial) == .freeTrial)
            }
        }

        @Test("maps payAsYouGo to payAsYouGo")
        func mapsPayAsYouGoToPayAsYouGo() {
            if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *) {
                #expect(IAPPaymentMode(Transaction.Offer.PaymentMode.payAsYouGo) == .payAsYouGo)
            }
        }

        @Test("maps payUpFront to payUpFront")
        func mapsPayUpFrontToPayUpFront() {
            if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *) {
                #expect(IAPPaymentMode(Transaction.Offer.PaymentMode.payUpFront) == .payUpFront)
            }
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *) {
                let mode: Transaction.Offer.PaymentMode? = nil
                #expect(IAPPaymentMode(mode) == .undefined)
            }
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPPaymentMode.undefined, "undefined"),
                (IAPPaymentMode.freeTrial, "freeTrial"),
                (IAPPaymentMode.payAsYouGo, "payAsYouGo"),
                (IAPPaymentMode.payUpFront, "payUpFront"),
            ]
        )
        func returnsExpectedDescriptionString(_ paymentMode: IAPPaymentMode, expectedDescription: String) {
            #expect(paymentMode.description == expectedDescription)
        }
    }
}

// MARK: - IAPPurchaseResultTests

@Suite("IAPPurchaseResult", .tags(.enumMapping, .properties))
struct IAPPurchaseResultTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPPurchaseResult.undefined, 0),
                (IAPPurchaseResult.success, 1),
                (IAPPurchaseResult.userCancelled, 2),
                (IAPPurchaseResult.pending, 3),
            ]
        )
        func hasExpectedRawValue(_ purchaseResult: IAPPurchaseResult, expectedRawValue: Int) {
            #expect(purchaseResult.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from Product.PurchaseResult

    @Suite("init from Product.PurchaseResult", .tags(.enumMapping))
    struct InitFromPurchaseResultTests {
        // NOTE: .success requires a VerificationResult<Transaction> which cannot be constructed
        // in a unit test context without a live StoreKit session. Only .userCancelled and
        // .pending are directly constructible and are tested here.

        @Test("maps userCancelled to userCancelled")
        func mapsUserCancelledToUserCancelled() {
            #expect(IAPPurchaseResult(Product.PurchaseResult.userCancelled) == .userCancelled)
        }

        @Test("maps pending to pending")
        func mapsPendingToPending() {
            #expect(IAPPurchaseResult(Product.PurchaseResult.pending) == .pending)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPPurchaseResult.undefined, "undefined"),
                (IAPPurchaseResult.success, "success"),
                (IAPPurchaseResult.userCancelled, "userCancelled"),
                (IAPPurchaseResult.pending, "pending"),
            ]
        )
        func returnsExpectedDescriptionString(_ purchaseResult: IAPPurchaseResult, expectedDescription: String) {
            #expect(purchaseResult.description == expectedDescription)
        }
    }
}
