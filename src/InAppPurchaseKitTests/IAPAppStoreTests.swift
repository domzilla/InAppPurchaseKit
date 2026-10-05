//
//  IAPAppStoreTests.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import StoreKit
import Testing
@testable import InAppPurchaseKit

@Suite("IAPAppStoreEnvironment")
struct IAPAppStoreEnvironmentTests {
    // MARK: Raw Values

    @Suite("raw values")
    struct RawValueTests {
        @Test(
            "has expected raw value",
            arguments: [
                (IAPAppStoreEnvironment.undefined, 0),
                (IAPAppStoreEnvironment.production, 1),
                (IAPAppStoreEnvironment.sandbox, 2),
                (IAPAppStoreEnvironment.xcode, 3),
            ]
        )
        func hasExpectedRawValue(_ environment: IAPAppStoreEnvironment, expectedRawValue: Int) {
            #expect(environment.rawValue == expectedRawValue)
        }
    }

    // MARK: Init from String

    @Suite("init from String")
    struct InitFromStringTests {
        @Test(
            "maps string case-insensitively to expected case",
            arguments: [
                ("production", IAPAppStoreEnvironment.production),
                ("sandbox", IAPAppStoreEnvironment.sandbox),
                ("xcode", IAPAppStoreEnvironment.xcode),
                ("PRODUCTION", IAPAppStoreEnvironment.production),
                ("Production", IAPAppStoreEnvironment.production),
                ("Sandbox", IAPAppStoreEnvironment.sandbox),
                ("XCODE", IAPAppStoreEnvironment.xcode),
            ]
        )
        func mapsStringToExpectedCase(_ description: String, expectedEnvironment: IAPAppStoreEnvironment) {
            #expect(IAPAppStoreEnvironment(description) == expectedEnvironment)
        }

        @Test("maps invalid string to undefined", arguments: ["", "unknown", "prod", "test"])
        func mapsInvalidStringToUndefined(_ description: String) {
            #expect(IAPAppStoreEnvironment(description) == .undefined)
        }
    }

    // MARK: Init from AppStore.Environment

    @Suite("init from AppStore.Environment")
    struct InitFromAppStoreEnvironmentTests {
        @Test(
            "maps StoreKit environment to expected case",
            arguments: [
                (AppStore.Environment.production, IAPAppStoreEnvironment.production),
                (AppStore.Environment.sandbox, IAPAppStoreEnvironment.sandbox),
                (AppStore.Environment.xcode, IAPAppStoreEnvironment.xcode),
            ]
        )
        func mapsStoreKitEnvironmentToExpectedCase(
            _ environment: AppStore.Environment,
            expectedEnvironment: IAPAppStoreEnvironment
        ) {
            #expect(IAPAppStoreEnvironment(environment) == expectedEnvironment)
        }
    }

    // MARK: Description

    @Suite("description")
    struct DescriptionTests {
        @Test(
            "returns expected description string",
            arguments: [
                (IAPAppStoreEnvironment.undefined, "undefined"),
                (IAPAppStoreEnvironment.production, "production"),
                (IAPAppStoreEnvironment.sandbox, "sandbox"),
                (IAPAppStoreEnvironment.xcode, "xcode"),
            ]
        )
        func returnsExpectedDescriptionString(_ environment: IAPAppStoreEnvironment, expectedDescription: String) {
            #expect(environment.description == expectedDescription)
        }

        @Test(
            "LosslessStringConvertible round-trip produces the same case",
            arguments: [
                IAPAppStoreEnvironment.undefined,
                IAPAppStoreEnvironment.production,
                IAPAppStoreEnvironment.sandbox,
                IAPAppStoreEnvironment.xcode,
            ]
        )
        func roundTripProducesSameCase(_ environment: IAPAppStoreEnvironment) {
            #expect(IAPAppStoreEnvironment(environment.description) == environment)
        }
    }
}
