//
//  IAPOfferTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

// MARK: - IAPOfferTypeTests

@Suite("IAPOfferType", .tags(.enumMapping, .properties))
struct IAPOfferTypeTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPOfferType.undefined, 0),
                (IAPOfferType.introductory, 1),
                (IAPOfferType.promotional, 2),
                (IAPOfferType.code, 3),
            ]
        )
        func hasExpectedRawValue(_ offerType: IAPOfferType, expectedRawValue: Int) {
            #expect(offerType.rawValue == expectedRawValue)
        }
    }

    // MARK: - Init from Transaction.OfferType

    @Suite("init from Transaction.OfferType", .tags(.enumMapping))
    struct InitFromTransactionOfferTypeTests {
        @Test("maps introductory to introductory")
        func mapsIntroductoryToIntroductory() {
            let offerType: Transaction.OfferType = .introductory
            #expect(IAPOfferType(offerType) == .introductory)
        }

        @Test("maps promotional to promotional")
        func mapsPromotionalToPromotional() {
            let offerType: Transaction.OfferType = .promotional
            #expect(IAPOfferType(offerType) == .promotional)
        }

        @Test("maps code to code")
        func mapsCodeToCode() {
            let offerType: Transaction.OfferType = .code
            #expect(IAPOfferType(offerType) == .code)
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            let offerType: Transaction.OfferType? = nil
            #expect(IAPOfferType(offerType) == .undefined)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPOfferType.undefined, "undefined"),
                (IAPOfferType.introductory, "introductory"),
                (IAPOfferType.promotional, "promotional"),
                (IAPOfferType.code, "code"),
            ]
        )
        func returnsExpectedDescriptionString(_ offerType: IAPOfferType, expectedDescription: String) {
            #expect(offerType.description == expectedDescription)
        }
    }
}

// MARK: - IAPOfferInitTests

@Suite("IAPOffer", .tags(.properties))
struct IAPOfferInitTests {
    // MARK: - Init

    @Suite("init(offerID:type:paymentMode:)", .tags(.properties))
    struct InitTests {
        @Test("stores offerID correctly")
        func storesOfferIDCorrectly() {
            let offer = IAPOffer(offerID: "promo_spring_2026", type: .promotional, paymentMode: .freeTrial)
            #expect(offer.offerID == "promo_spring_2026")
        }

        @Test("stores type correctly")
        func storesTypeCorrectly() {
            let offer = IAPOffer(offerID: "promo_spring_2026", type: .promotional, paymentMode: .freeTrial)
            #expect(offer.type == .promotional)
        }

        @Test("stores paymentMode correctly")
        func storesPaymentModeCorrectly() {
            let offer = IAPOffer(offerID: "promo_spring_2026", type: .promotional, paymentMode: .freeTrial)
            #expect(offer.paymentMode == .freeTrial)
        }

        @Test("stores nil offerID correctly")
        func storesNilOfferIDCorrectly() {
            let offer = IAPOffer(offerID: nil, type: .introductory, paymentMode: .freeTrial)
            #expect(offer.offerID == nil)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.stringParsing, .properties))
    struct DescriptionTests {
        @Test("description contains offerID")
        func descriptionContainsOfferID() {
            let offer = IAPOffer(offerID: "promo_spring_2026", type: .promotional, paymentMode: .payAsYouGo)
            #expect(offer.description.contains("promo_spring_2026"))
        }

        @Test("description contains type description")
        func descriptionContainsTypeDescription() {
            let offer = IAPOffer(offerID: "promo_spring_2026", type: .promotional, paymentMode: .payAsYouGo)
            #expect(offer.description.contains("promotional"))
        }

        @Test("description contains paymentMode description")
        func descriptionContainsPaymentModeDescription() {
            let offer = IAPOffer(offerID: "promo_spring_2026", type: .promotional, paymentMode: .payAsYouGo)
            #expect(offer.description.contains("payAsYouGo"))
        }

        @Test("description contains nil literal when offerID is nil")
        func descriptionContainsNilLiteralWhenOfferIDIsNil() {
            let offer = IAPOffer(offerID: nil, type: .introductory, paymentMode: .freeTrial)
            #expect(offer.description.contains("nil"))
        }
    }
}
