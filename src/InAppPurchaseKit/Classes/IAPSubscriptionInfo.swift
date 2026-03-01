//
//  IAPSubscriptionInfo.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

/// An Objective-C compatible wrapper around `Product.SubscriptionInfo`.
///
/// Provides subscription-specific metadata for an auto-renewable subscription product,
/// including the subscription group, renewal period, introductory and promotional offers,
/// and methods to query subscription status and introductory offer eligibility.
///
/// - Note: This class bridges StoreKit2's `Product.SubscriptionInfo` to Objective-C via `@objc`.
///   Use the instance methods and properties to access subscription details without
///   interacting with StoreKit2 directly.
@objc
public class IAPSubscriptionInfo: NSObject {
    let subscriptionInfo: Product.SubscriptionInfo

    // MARK: Public Properties

    // MARK: - -

    /// The identifier of the subscription group this product belongs to.
    ///
    /// All auto-renewable subscriptions must belong to a group. Products within
    /// the same group are mutually exclusive -- a subscriber can only subscribe
    /// to one product in a group at a time.
    ///
    /// Wraps `Product.SubscriptionInfo.subscriptionGroupID`.
    @objc public let subscriptionGroupID: String

    /// The localized display name of the subscription group.
    ///
    /// This is the name you configure in App Store Connect for the subscription group.
    ///
    /// Wraps `Product.SubscriptionInfo.groupDisplayName`.
    ///
    /// - Note: Available on iOS 16.4+, macOS 13.3+, tvOS 16.4+, watchOS 9.4+, and visionOS 1.0+.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, visionOS 1.0, *)
    @objc public var groupDisplayName: String {
        self.subscriptionInfo.groupDisplayName
    }

    /// The level of service for this subscription within its subscription group.
    ///
    /// Lower values represent higher levels of service. The App Store uses this value
    /// to determine upgrade and downgrade behavior when a subscriber changes products
    /// within the same group.
    ///
    /// Wraps `Product.SubscriptionInfo.groupLevel`.
    ///
    /// - Note: Available on iOS 16.4+, macOS 13.3+, tvOS 16.4+, watchOS 9.4+, and visionOS 1.0+.
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, visionOS 1.0, *)
    @objc public var groupLevel: Int {
        self.subscriptionInfo.groupLevel
    }

    /// The duration of one subscription period.
    ///
    /// Represents the billing cycle length (e.g., one week, one month, one year)
    /// as an ``IAPSubscriptionPeriod`` instance.
    ///
    /// Wraps `Product.SubscriptionInfo.subscriptionPeriod`.
    @objc public let subscriptionPeriod: IAPSubscriptionPeriod

    /// The introductory offer for this subscription, if one exists.
    ///
    /// Introductory offers provide a discounted price or free trial to new subscribers.
    /// Returns `nil` if the product has no introductory offer configured.
    ///
    /// Wraps `Product.SubscriptionInfo.introductoryOffer`.
    ///
    /// - Note: Use ``isEligibleForIntroOffer()`` to check whether the current user
    ///   qualifies for this offer before presenting it.
    @objc public let introductoryOffer: IAPSubscriptionOffer?

    /// The promotional offers configured for this subscription.
    ///
    /// Promotional offers allow you to offer a discounted price to existing or lapsed
    /// subscribers. Each offer is represented as an ``IAPSubscriptionOffer`` instance.
    /// Returns an empty array if no promotional offers are configured.
    ///
    /// Wraps `Product.SubscriptionInfo.promotionalOffers`.
    @objc public let promotionalOffers: [IAPSubscriptionOffer]

    // MARK: Init

    // MARK: - -

    /// Creates a new instance by wrapping a StoreKit2 `Product.SubscriptionInfo`.
    ///
    /// - Parameter fromSubscriptionInfo: The `Product.SubscriptionInfo` value to wrap.
    init(_ fromSubscriptionInfo: Product.SubscriptionInfo) {
        self.subscriptionInfo = fromSubscriptionInfo

        self.subscriptionGroupID = self.subscriptionInfo.subscriptionGroupID
        self.subscriptionPeriod = IAPSubscriptionPeriod(self.subscriptionInfo.subscriptionPeriod)

        if let introductoryOffer = self.subscriptionInfo.introductoryOffer {
            self.introductoryOffer = IAPSubscriptionOffer(introductoryOffer)
        } else {
            self.introductoryOffer = nil
        }

        var promotionalOffers: [IAPSubscriptionOffer] = []
        for promotionalOffer in self.subscriptionInfo.promotionalOffers {
            promotionalOffers.append(IAPSubscriptionOffer(promotionalOffer))
        }
        self.promotionalOffers = promotionalOffers
    }

    // MARK: Public

    // MARK: - -

    /// Retrieves the current subscription statuses for this product's subscription group.
    ///
    /// Queries the App Store for the latest subscription status of all products in the
    /// same subscription group as this product. Each returned ``IAPSubscriptionStatus``
    /// contains the renewal state, transaction, and renewal information.
    ///
    /// Wraps `Product.SubscriptionInfo.status`.
    ///
    /// - Returns: An array of ``IAPSubscriptionStatus`` objects representing the current
    ///   status of each subscription in the group.
    /// - Throws: An error if the status cannot be retrieved from the App Store.
    @objc
    public func status() async throws -> [IAPSubscriptionStatus] {
        let statuses = try await self.subscriptionInfo.status
        var subscriptionStatuses: [IAPSubscriptionStatus] = []
        for status in statuses {
            subscriptionStatuses.append(IAPSubscriptionStatus(status))
        }

        return subscriptionStatuses
    }

    /// Retrieves the current subscription statuses for a specific subscription group.
    ///
    /// Queries the App Store for the latest subscription status of all products in the
    /// subscription group identified by the given group ID. This is useful when you need
    /// to check status without having a specific product reference.
    ///
    /// Wraps `Product.SubscriptionInfo.status(for:)`.
    ///
    /// - Parameter groupID: The identifier of the subscription group to query.
    /// - Returns: An array of ``IAPSubscriptionStatus`` objects representing the current
    ///   status of each subscription in the group.
    /// - Throws: An error if the status cannot be retrieved from the App Store.
    @objc
    public static func status(forGroupID groupID: String) async throws -> [IAPSubscriptionStatus] {
        let statuses = try await Product.SubscriptionInfo.status(for: groupID)
        var subscriptionStatuses: [IAPSubscriptionStatus] = []
        for status in statuses {
            subscriptionStatuses.append(IAPSubscriptionStatus(status))
        }

        return subscriptionStatuses
    }

    /// Checks whether the current user is eligible for an introductory offer in the specified subscription group.
    ///
    /// A user is eligible if they have never subscribed to any product in the given
    /// subscription group, or if the App Store otherwise determines eligibility.
    ///
    /// Wraps `Product.SubscriptionInfo.isEligibleForIntroOffer(for:)`.
    ///
    /// - Parameter groupID: The identifier of the subscription group to check eligibility for.
    /// - Returns: `true` if the user is eligible for an introductory offer in the group; `false` otherwise.
    @objc
    public static func isEligibleForIntroOffer(for groupID: String) async -> Bool {
        await Product.SubscriptionInfo.isEligibleForIntroOffer(for: groupID)
    }

    /// Checks whether the current user is eligible for the introductory offer of this subscription product.
    ///
    /// A user is eligible if they have never subscribed to any product in this
    /// product's subscription group, or if the App Store otherwise determines eligibility.
    ///
    /// Wraps `Product.SubscriptionInfo.isEligibleForIntroOffer`.
    ///
    /// - Returns: `true` if the user is eligible for this product's introductory offer; `false` otherwise.
    @objc
    public func isEligibleForIntroOffer() async -> Bool {
        await self.subscriptionInfo.isEligibleForIntroOffer
    }
}
