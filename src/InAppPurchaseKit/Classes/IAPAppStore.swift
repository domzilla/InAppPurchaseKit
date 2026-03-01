//
//  IAPAppStore.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

/// Represents the App Store environment in which the app is running.
///
/// Wraps `StoreKit.AppStore.Environment` as an Objective-C compatible integer-backed enum.
/// Conforms to `LosslessStringConvertible` for easy conversion to and from string representations.
///
/// - Note: The ``undefined`` case serves as a fallback for unknown or future StoreKit environment values.
@objc
public enum IAPAppStoreEnvironment: Int, LosslessStringConvertible {
    /// A fallback value indicating an unknown or unsupported App Store environment.
    case undefined = 0

    /// The production App Store environment.
    case production
    /// The sandbox testing environment used for App Store Connect test accounts.
    case sandbox
    /// The local Xcode testing environment used with StoreKit Configuration files.
    case xcode

    /// Creates an environment value from a StoreKit `AppStore.Environment`.
    ///
    /// Maps known StoreKit environments to their corresponding enum cases.
    /// Unknown or future environment values are mapped to ``undefined``.
    ///
    /// - Parameter environment: The StoreKit `AppStore.Environment` value to convert.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
    public init(_ environment: AppStore.Environment) {
        switch environment {
        case .production:
            self = .production
        case .sandbox:
            self = .sandbox
        case .xcode:
            self = .xcode
        default:
            self = .undefined
        }
    }

    /// Creates an environment value from a string description.
    ///
    /// Performs a case-insensitive comparison. Unrecognized strings are mapped to ``undefined``.
    ///
    /// - Parameter description: A string representation of the environment
    ///   (e.g., `"production"`, `"sandbox"`, `"xcode"`).
    public init(_ description: String) {
        switch description.lowercased() {
        case "production":
            self = .production
        case "sandbox":
            self = .sandbox
        case "xcode":
            self = .xcode
        default:
            self = .undefined
        }
    }

    /// A lowercase string representation of the environment.
    ///
    /// Returns `"production"`, `"sandbox"`, `"xcode"`, or `"undefined"`.
    public var description: String {
        switch self {
        case .production:
            "production"
        case .sandbox:
            "sandbox"
        case .xcode:
            "xcode"
        case .undefined:
            "undefined"
        }
    }
}

/// Provides Objective-C compatible access to App Store functionality.
///
/// Wraps static methods and properties from `StoreKit.AppStore`, exposing them
/// via `@objc` annotations for use in Objective-C codebases. Includes payment
/// availability checks, device verification, subscription management,
/// review requests, offer code redemption, and App Store sync.
@objc
public class IAPAppStore: NSObject {
    // MARK: Public Properties

    // MARK: - --

    /// A Boolean value that indicates whether the user is allowed to make payments.
    ///
    /// Wraps `AppStore.canMakePayments`. Returns `false` if the device or user account
    /// has payment restrictions enabled (e.g., parental controls).
    @objc public static var canMakePayments: Bool {
        AppStore.canMakePayments
    }

    /// The UUID used to verify that the device is the one that originally performed a transaction.
    ///
    /// Wraps `AppStore.deviceVerificationID`. Returns `nil` if the device verification ID
    /// is unavailable.
    @objc public static var deviceVerificationID: UUID? {
        AppStore.deviceVerificationID
    }

    // MARK: Public

    // MARK: - --

    #if os(iOS)
    /// Presents the system subscription management sheet in the specified window scene.
    ///
    /// Wraps `AppStore.showManageSubscriptions(in:)`. Displays the standard App Store
    /// UI that allows users to view, modify, or cancel their subscriptions.
    ///
    /// - Parameter scene: The `UIWindowScene` in which to present the subscription management sheet.
    /// - Throws: An error if the subscription management sheet could not be presented.
    @objc
    public static func showManageSubscriptions(in scene: UIWindowScene) async throws {
        try await AppStore.showManageSubscriptions(in: scene)
    }

    /// Presents the system subscription management sheet for a specific subscription group.
    ///
    /// Wraps `AppStore.showManageSubscriptions(in:subscriptionGroupID:)`. When a
    /// `subscriptionGroupID` is provided, the sheet is scoped to that group. When `nil`,
    /// the sheet shows all subscriptions (equivalent to calling the single-parameter variant).
    ///
    /// - Parameter scene: The `UIWindowScene` in which to present the subscription management sheet.
    /// - Parameter subscriptionGroupID: The subscription group identifier to scope the sheet to,
    ///   or `nil` to show all subscriptions.
    /// - Throws: An error if the subscription management sheet could not be presented.
    @available(iOS 17.0, *)
    @objc
    public static func showManageSubscriptions(
        in scene: UIWindowScene,
        subscriptionGroupID: String?
    ) async throws {
        if let subscriptionGroupID {
            try await AppStore.showManageSubscriptions(in: scene, subscriptionGroupID: subscriptionGroupID)
        } else {
            try await AppStore.showManageSubscriptions(in: scene)
        }
    }

    /// Requests the user to rate or review the app using the system prompt.
    ///
    /// Wraps `AppStore.requestReview(in:)`. The system may choose not to display
    /// the review prompt depending on App Store policy and rate limits.
    ///
    /// - Parameter scene: The `UIWindowScene` in which to present the review request.
    /// - Note: This method must be called on the main actor.
    @MainActor @available(iOS 16.0, *)
    @objc
    public static func requestReview(in scene: UIWindowScene) {
        AppStore.requestReview(in: scene)
    }

    /// Presents the offer code redemption sheet in the specified window scene.
    ///
    /// Wraps `AppStore.presentOfferCodeRedeemSheet(in:)`. Displays the standard
    /// App Store UI for entering and redeeming subscription offer codes.
    ///
    /// - Parameter scene: The `UIWindowScene` in which to present the offer code redemption sheet.
    /// - Throws: An error if the offer code redemption sheet could not be presented.
    /// - Note: This method must be called on the main actor.
    @MainActor @available(iOS 16.0, *)
    @objc
    public static func presentOfferCodeRedeemSheet(in scene: UIWindowScene) async throws {
        try await AppStore.presentOfferCodeRedeemSheet(in: scene)
    }
    #endif

    /// Synchronizes the user's App Store transactions with the device.
    ///
    /// Wraps `AppStore.sync()`. Forces a refresh of the user's transaction history
    /// from the App Store, ensuring that all completed transactions are available locally.
    /// This is useful for restoring purchases or resolving missing transactions.
    ///
    /// - Throws: An error if the sync operation fails (e.g., due to network issues).
    @objc
    public static func sync() async throws {
        try await AppStore.sync()
    }
}
