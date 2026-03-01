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

// MARK: - IAPSubscriptionPeriodTests

@Suite("IAPSubscriptionPeriodUnit Tests", .tags(.enumMapping))
struct IAPSubscriptionPeriodTests {
    // MARK: - Raw Values

    @Suite("raw values", .tags(.enumMapping, .properties))
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

    // MARK: - Init from SubscriptionPeriod.Unit

    @Suite("init from SubscriptionPeriod.Unit", .tags(.enumMapping))
    struct InitTests {
        @Test("maps day to day")
        func mapsDayToDay() {
            #expect(IAPSubscriptionPeriodUnit(.day) == .day)
        }

        @Test("maps month to month")
        func mapsMonthToMonth() {
            #expect(IAPSubscriptionPeriodUnit(.month) == .month)
        }

        @Test("maps week to week")
        func mapsWeekToWeek() {
            #expect(IAPSubscriptionPeriodUnit(.week) == .week)
        }

        @Test("maps year to year")
        func mapsYearToYear() {
            #expect(IAPSubscriptionPeriodUnit(.year) == .year)
        }
    }

    // MARK: - Description

    @Suite("description", .tags(.properties))
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPSubscriptionPeriodUnit.day, "day"),
                (IAPSubscriptionPeriodUnit.month, "month"),
                (IAPSubscriptionPeriodUnit.week, "week"),
                (IAPSubscriptionPeriodUnit.year, "year"),
                (IAPSubscriptionPeriodUnit.undefined, "undefined"),
            ]
        )
        func returnsExpectedDescriptionString(_ unit: IAPSubscriptionPeriodUnit, expectedDescription: String) {
            #expect(unit.description == expectedDescription)
        }
    }
}
