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

// MARK: - IAPSubscriptionOfferTests

@Suite("IAPSubscriptionOffer Tests")
struct IAPSubscriptionOfferTests {
    // MARK: - IAPOfferType Init from SubscriptionOffer.OfferType

    @Suite("IAPOfferType init from SubscriptionOffer.OfferType", .tags(.enumMapping))
    struct OfferTypeFromSubscriptionOfferTypeTests {
        @Test("maps introductory to introductory")
        func mapsIntroductoryToIntroductory() {
            #expect(IAPOfferType(Product.SubscriptionOffer.OfferType.introductory) == .introductory)
        }

        @Test("maps promotional to promotional")
        func mapsPromotionalToPromotional() {
            #expect(IAPOfferType(Product.SubscriptionOffer.OfferType.promotional) == .promotional)
        }

        @Test("maps nil to undefined")
        func mapsNilToUndefined() {
            #expect(IAPOfferType(nil as Product.SubscriptionOffer.OfferType?) == .undefined)
        }
    }
}
