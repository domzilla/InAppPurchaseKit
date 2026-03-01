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

// MARK: - IAPAppStoreTests

@Suite("IAPAppStore Tests")
struct IAPAppStoreTests {
    // MARK: - IAPAppStoreEnvironment

    @Suite("IAPAppStoreEnvironment", .tags(.enumMapping))
    struct IAPAppStoreEnvironmentTests {
        // MARK: - Raw Values

        @Suite("Raw Values", .tags(.properties))
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

        // MARK: - Init from String

        @Suite("Init from String", .tags(.stringParsing))
        struct InitFromStringTests {
            @Test(
                "maps valid lowercase string to expected case",
                arguments: [
                    ("production", IAPAppStoreEnvironment.production),
                    ("sandbox", IAPAppStoreEnvironment.sandbox),
                    ("xcode", IAPAppStoreEnvironment.xcode),
                ]
            )
            func mapsValidLowercaseStringToExpectedCase(
                _ description: String,
                expectedEnvironment: IAPAppStoreEnvironment
            ) {
                #expect(IAPAppStoreEnvironment(description) == expectedEnvironment)
            }

            @Test(
                "maps valid mixed-case string to expected case",
                arguments: [
                    ("PRODUCTION", IAPAppStoreEnvironment.production),
                    ("Sandbox", IAPAppStoreEnvironment.sandbox),
                    ("XCODE", IAPAppStoreEnvironment.xcode),
                    ("Production", IAPAppStoreEnvironment.production),
                ]
            )
            func mapsValidMixedCaseStringToExpectedCase(
                _ description: String,
                expectedEnvironment: IAPAppStoreEnvironment
            ) {
                #expect(IAPAppStoreEnvironment(description) == expectedEnvironment)
            }

            @Test(
                "maps invalid string to undefined",
                arguments: [
                    ("", IAPAppStoreEnvironment.undefined),
                    ("unknown", IAPAppStoreEnvironment.undefined),
                    ("prod", IAPAppStoreEnvironment.undefined),
                    ("test", IAPAppStoreEnvironment.undefined),
                ]
            )
            func mapsInvalidStringToUndefined(_ description: String, expectedEnvironment: IAPAppStoreEnvironment) {
                #expect(IAPAppStoreEnvironment(description) == expectedEnvironment)
            }
        }

        // MARK: - Init from AppStore.Environment

        @Suite("Init from AppStore.Environment", .tags(.enumMapping))
        struct InitFromAppStoreEnvironmentTests {
            @Test("maps AppStore.Environment.production to production")
            func mapsProductionToProduction() {
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
                    #expect(IAPAppStoreEnvironment(.production) == .production)
                }
            }

            @Test("maps AppStore.Environment.sandbox to sandbox")
            func mapsSandboxToSandbox() {
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
                    #expect(IAPAppStoreEnvironment(.sandbox) == .sandbox)
                }
            }

            @Test("maps AppStore.Environment.xcode to xcode")
            func mapsXcodeToXcode() {
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
                    #expect(IAPAppStoreEnvironment(.xcode) == .xcode)
                }
            }
        }

        // MARK: - Description

        @Suite("Description", .tags(.properties))
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
        }

        // MARK: - Round Trip

        @Suite("Round Trip", .tags(.properties))
        struct RoundTripTests {
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
}
