//
//  IAPSubscriptionOffer.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

/// Extends ``IAPOfferType`` with an initializer that converts from StoreKit2's
/// `Product.SubscriptionOffer.OfferType`.
///
/// - Note: The `code` offer type is not available on `Product.SubscriptionOffer.OfferType`,
///   so only `introductory` and `promotional` are mapped. All other values default to ``IAPOfferType/undefined``.
extension IAPOfferType {
    /// Creates an ``IAPOfferType`` from a StoreKit2 `Product.SubscriptionOffer.OfferType`.
    ///
    /// - Parameter offerType: The StoreKit2 offer type to convert, or `nil`.
    ///   A `nil` value results in ``IAPOfferType/undefined``.
    public init(_ offerType: Product.SubscriptionOffer.OfferType?) {
        switch offerType {
        case .introductory:
            self = .introductory
        case .promotional:
            self = .promotional
        default:
            self = .undefined
        }
    }
}

/// An Objective-C compatible wrapper around StoreKit2's `Product.SubscriptionOffer`.
///
/// `IAPSubscriptionOffer` extends ``IAPOffer`` with subscription-specific pricing and
/// period information, such as the offer's display price, decimal price value,
/// subscription period, and the number of periods the offer applies for.
///
/// This class is intended for use in Objective-C codebases that need access to
/// modern StoreKit2 subscription offer details.
///
/// - Note: Instances are created internally by the framework when processing
///   subscription product data from StoreKit2. The initializer is not public.
@objc
public class IAPSubscriptionOffer: IAPOffer {
    /// The underlying StoreKit2 `Product.SubscriptionOffer` that this instance wraps.
    let subscriptionOffer: Product.SubscriptionOffer

    // MARK: Public Properties

    // MARK: - -

    /// A localized string representation of the offer's price, formatted for display
    /// in the user's locale (e.g., "$0.99", "0,99 EUR").
    ///
    /// Wraps `Product.SubscriptionOffer.displayPrice`.
    @objc public let displayPrice: String

    /// The decimal price of the subscription offer.
    ///
    /// Wraps `Product.SubscriptionOffer.price`.
    @objc public let price: Decimal

    /// The subscription period for this offer, describing the duration and unit
    /// (e.g., 1 week, 3 months).
    ///
    /// Wraps `Product.SubscriptionOffer.period` as an ``IAPSubscriptionPeriod``.
    @objc public let period: IAPSubscriptionPeriod

    /// The number of subscription periods that this offer applies for.
    ///
    /// For example, a value of `3` combined with a monthly period means the offer
    /// lasts for three months.
    ///
    /// Wraps `Product.SubscriptionOffer.periodCount`.
    @objc public let periodCount: Int

    // MARK: Init

    // MARK: - -

    /// Creates an ``IAPSubscriptionOffer`` from a StoreKit2 `Product.SubscriptionOffer`.
    ///
    /// Extracts the display price, decimal price, subscription period, and period count
    /// from the StoreKit2 offer, and passes the offer ID, type, and payment mode to
    /// the ``IAPOffer`` superclass.
    ///
    /// - Parameter fromSubscriptionOffer: The StoreKit2 `Product.SubscriptionOffer` to wrap.
    init(_ fromSubscriptionOffer: Product.SubscriptionOffer) {
        self.subscriptionOffer = fromSubscriptionOffer

        self.displayPrice = self.subscriptionOffer.displayPrice
        self.price = self.subscriptionOffer.price
        self.period = IAPSubscriptionPeriod(self.subscriptionOffer.period)
        self.periodCount = self.subscriptionOffer.periodCount

        super.init(
            offerID: fromSubscriptionOffer.id,
            type: IAPOfferType(fromSubscriptionOffer.type),
            paymentMode: IAPPaymentMode(fromSubscriptionOffer.paymentMode)
        )
    }
}
