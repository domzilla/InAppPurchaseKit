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

@Suite("IAPOfferType")
struct IAPOfferTypeTests {
    // MARK: Raw Values

    @Suite("raw values")
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

    // MARK: Init from Transaction.OfferType

    @Suite("init from Transaction.OfferType")
    struct InitFromTransactionOfferTypeTests {
        @Test(
            "maps StoreKit offer type to expected case",
            arguments: [
                (Transaction.OfferType?.some(.introductory), IAPOfferType.introductory),
                (Transaction.OfferType?.some(.promotional), IAPOfferType.promotional),
                (Transaction.OfferType?.some(.code), IAPOfferType.code),
                (Transaction.OfferType?.none, IAPOfferType.undefined),
            ]
        )
        func mapsStoreKitOfferTypeToExpectedCase(
            _ offerType: Transaction.OfferType?,
            expectedOfferType: IAPOfferType
        ) {
            #expect(IAPOfferType(offerType) == expectedOfferType)
        }
    }

    // MARK: Description

    @Suite("description")
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

@Suite("IAPOffer")
struct IAPOfferTests {
    static let offerID = "promo_spring_2026"

    // MARK: Init

    @Suite("init(offerID:type:paymentMode:)")
    struct InitTests {
        @Test("stores the given values")
        func storesGivenValues() {
            let offer = IAPOffer(offerID: IAPOfferTests.offerID, type: .promotional, paymentMode: .freeTrial)
            #expect(offer.offerID == IAPOfferTests.offerID)
            #expect(offer.type == .promotional)
            #expect(offer.paymentMode == .freeTrial)
        }

        @Test("stores nil offerID")
        func storesNilOfferID() {
            let offer = IAPOffer(offerID: nil, type: .introductory, paymentMode: .freeTrial)
            #expect(offer.offerID == nil)
        }
    }

    // MARK: Description

    @Suite("description")
    struct DescriptionTests {
        @Test("lists offerID, type and paymentMode")
        func listsOfferIDTypeAndPaymentMode() {
            let offer = IAPOffer(offerID: IAPOfferTests.offerID, type: .promotional, paymentMode: .payAsYouGo)
            #expect(offer.description.contains("offerID: \(IAPOfferTests.offerID) \n"))
            #expect(offer.description.contains("type: promotional \n"))
            #expect(offer.description.contains("paymentMode: payAsYouGo \n"))
        }

        @Test("lists nil literal when offerID is nil")
        func listsNilLiteralWhenOfferIDIsNil() {
            let offer = IAPOffer(offerID: nil, type: .introductory, paymentMode: .freeTrial)
            #expect(offer.description.contains("offerID: nil \n"))
        }
    }
}
