//
//  IAPSubscriptionPeriodTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

@Suite("IAPSubscriptionPeriodUnit")
struct IAPSubscriptionPeriodUnitTests {
    // MARK: Raw Values

    @Suite("raw values")
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPSubscriptionPeriodUnit.undefined, 0),
                (IAPSubscriptionPeriodUnit.day, 1),
                (IAPSubscriptionPeriodUnit.month, 2),
                (IAPSubscriptionPeriodUnit.week, 3),
                (IAPSubscriptionPeriodUnit.year, 4),
            ]
        )
        func hasExpectedRawValue(_ unit: IAPSubscriptionPeriodUnit, expectedRawValue: Int) {
            #expect(unit.rawValue == expectedRawValue)
        }
    }

    // MARK: Init from Product.SubscriptionPeriod.Unit

    @Suite("init from Product.SubscriptionPeriod.Unit")
    struct InitTests {
        @Test(
            "maps StoreKit unit to expected case",
            arguments: [
                (Product.SubscriptionPeriod.Unit.day, IAPSubscriptionPeriodUnit.day),
                (Product.SubscriptionPeriod.Unit.week, IAPSubscriptionPeriodUnit.week),
                (Product.SubscriptionPeriod.Unit.month, IAPSubscriptionPeriodUnit.month),
                (Product.SubscriptionPeriod.Unit.year, IAPSubscriptionPeriodUnit.year),
            ]
        )
        func mapsStoreKitUnitToExpectedCase(
            _ unit: Product.SubscriptionPeriod.Unit,
            expectedUnit: IAPSubscriptionPeriodUnit
        ) {
            #expect(IAPSubscriptionPeriodUnit(unit) == expectedUnit)
        }
    }

    // MARK: Description

    @Suite("description")
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPSubscriptionPeriodUnit.undefined, "undefined"),
                (IAPSubscriptionPeriodUnit.day, "day"),
                (IAPSubscriptionPeriodUnit.month, "month"),
                (IAPSubscriptionPeriodUnit.week, "week"),
                (IAPSubscriptionPeriodUnit.year, "year"),
            ]
        )
        func returnsExpectedDescriptionString(_ unit: IAPSubscriptionPeriodUnit, expectedDescription: String) {
            #expect(unit.description == expectedDescription)
        }
    }
}
