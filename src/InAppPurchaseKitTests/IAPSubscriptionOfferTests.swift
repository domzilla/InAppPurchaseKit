//
//  IAPSubscriptionOfferTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

@Suite("IAPOfferType init from Product.SubscriptionOffer.OfferType")
struct IAPSubscriptionOfferTests {
    @Test(
        "maps StoreKit subscription offer type to expected case",
        arguments: [
            (Product.SubscriptionOffer.OfferType?.some(.introductory), IAPOfferType.introductory),
            (Product.SubscriptionOffer.OfferType?.some(.promotional), IAPOfferType.promotional),
            (Product.SubscriptionOffer.OfferType?.none, IAPOfferType.undefined),
        ]
    )
    func mapsStoreKitSubscriptionOfferTypeToExpectedCase(
        _ offerType: Product.SubscriptionOffer.OfferType?,
        expectedOfferType: IAPOfferType
    ) {
        #expect(IAPOfferType(offerType) == expectedOfferType)
    }
}
