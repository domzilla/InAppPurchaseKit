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

@Suite("IAPProductType")
struct IAPProductTypeTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from Product.ProductType

    @Suite("init from Product.ProductType")
    struct InitFromProductTypeTests {
        @Test(
            "maps StoreKit product type to expected case",
            arguments: [
                (Product.ProductType.consumable, IAPProductType.consumable),
                (Product.ProductType.nonConsumable, IAPProductType.nonConsumable),
                (Product.ProductType.nonRenewable, IAPProductType.nonRenewable),
                (Product.ProductType.autoRenewable, IAPProductType.autoRenewable),
            ]
        )
        func mapsStoreKitProductTypeToExpectedCase(
            _ productType: Product.ProductType,
            expectedProductType: IAPProductType
        ) {
            #expect(IAPProductType(productType) == expectedProductType)
        }
    }

    // MARK: Description

    @Suite("description")
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

@Suite("IAPPaymentMode")
struct IAPPaymentModeTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from String

    @Suite("init from String")
    struct InitFromStringTests {
        @Test(
            "maps snake_case string case-insensitively to expected payment mode",
            arguments: [
                ("free_trial", IAPPaymentMode.freeTrial),
                ("pay_as_you_go", IAPPaymentMode.payAsYouGo),
                ("pay_up_front", IAPPaymentMode.payUpFront),
                ("FREE_TRIAL", IAPPaymentMode.freeTrial),
                ("Free_Trial", IAPPaymentMode.freeTrial),
                ("PAY_AS_YOU_GO", IAPPaymentMode.payAsYouGo),
                ("PAY_UP_FRONT", IAPPaymentMode.payUpFront),
            ]
        )
        func mapsStringToExpectedPaymentMode(_ input: String, expectedMode: IAPPaymentMode) {
            #expect(IAPPaymentMode(input) == expectedMode)
        }

        @Test(
            "maps invalid string to undefined",
            arguments: ["", "unknown", "freeTrialX", "free trial", "payasYouGo"]
        )
        func mapsInvalidStringToUndefined(_ input: String) {
            #expect(IAPPaymentMode(input) == .undefined)
        }
    }

    // MARK: Init from Product.SubscriptionOffer.PaymentMode

    @Suite("init from Product.SubscriptionOffer.PaymentMode")
    struct InitFromSubscriptionOfferPaymentModeTests {
        @Test(
            "maps StoreKit payment mode to expected case",
            arguments: [
                (Product.SubscriptionOffer.PaymentMode.freeTrial, IAPPaymentMode.freeTrial),
                (Product.SubscriptionOffer.PaymentMode.payAsYouGo, IAPPaymentMode.payAsYouGo),
                (Product.SubscriptionOffer.PaymentMode.payUpFront, IAPPaymentMode.payUpFront),
            ]
        )
        func mapsStoreKitPaymentModeToExpectedCase(
            _ paymentMode: Product.SubscriptionOffer.PaymentMode,
            expectedMode: IAPPaymentMode
        ) {
            #expect(IAPPaymentMode(paymentMode) == expectedMode)
        }
    }

    // MARK: Init from Transaction.Offer.PaymentMode

    @Suite("init from Transaction.Offer.PaymentMode")
    struct InitFromTransactionOfferPaymentModeTests {
        @Test(
            "maps StoreKit payment mode to expected case",
            arguments: [
                (Transaction.Offer.PaymentMode?.some(.freeTrial), IAPPaymentMode.freeTrial),
                (Transaction.Offer.PaymentMode?.some(.payAsYouGo), IAPPaymentMode.payAsYouGo),
                (Transaction.Offer.PaymentMode?.some(.payUpFront), IAPPaymentMode.payUpFront),
                (Transaction.Offer.PaymentMode?.none, IAPPaymentMode.undefined),
            ]
        )
        func mapsStoreKitPaymentModeToExpectedCase(
            _ paymentMode: Transaction.Offer.PaymentMode?,
            expectedMode: IAPPaymentMode
        ) {
            #expect(IAPPaymentMode(paymentMode) == expectedMode)
        }
    }

    // MARK: Description

    @Suite("description")
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

        @Test(
            "LosslessStringConvertible round-trip produces the same case",
            arguments: [
                IAPPaymentMode.undefined,
                IAPPaymentMode.freeTrial,
                IAPPaymentMode.payAsYouGo,
                IAPPaymentMode.payUpFront,
            ]
        )
        func roundTripProducesSameCase(_ paymentMode: IAPPaymentMode) {
            withKnownIssue("Framework bug: description is camelCase but init(_: String) only parses snake_case") {
                #expect(IAPPaymentMode(paymentMode.description) == paymentMode)
            } when: {
                paymentMode != .undefined
            }
        }
    }
}

@Suite("IAPPurchaseResult")
struct IAPPurchaseResultTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from Product.PurchaseResult

    /// `.success` is not covered: it needs a `VerificationResult<Transaction>`, which only a live StoreKit session
    /// can produce.
    @Suite("init from Product.PurchaseResult")
    struct InitFromPurchaseResultTests {
        @Test(
            "maps StoreKit purchase result to expected case",
            arguments: [
                (Product.PurchaseResult.userCancelled, IAPPurchaseResult.userCancelled),
                (Product.PurchaseResult.pending, IAPPurchaseResult.pending),
            ]
        )
        func mapsStoreKitPurchaseResultToExpectedCase(
            _ purchaseResult: Product.PurchaseResult,
            expectedResult: IAPPurchaseResult
        ) {
            #expect(IAPPurchaseResult(purchaseResult) == expectedResult)
        }
    }

    // MARK: Description

    @Suite("description")
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
