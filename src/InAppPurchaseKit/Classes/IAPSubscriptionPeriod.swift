//
//  IAPSubscriptionPeriod.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

/// An Objective-C compatible representation of a subscription period's time unit.
///
/// Wraps `Product.SubscriptionPeriod.Unit` from StoreKit2, providing an `@objc`-accessible
/// integer-backed enum for use in Objective-C codebases.
@objc
public enum IAPSubscriptionPeriodUnit: Int {
    /// A fallback value representing an unknown or unsupported period unit.
    ///
    /// - Note: This case is used when StoreKit returns a period unit that is not yet
    ///   handled by this framework, such as values introduced in future OS versions.
    case undefined = 0

    /// A period unit measured in days.
    case day

    /// A period unit measured in months.
    case month

    /// A period unit measured in weeks.
    case week

    /// A period unit measured in years.
    case year

    /// Creates a subscription period unit from a StoreKit2 `Product.SubscriptionPeriod.Unit`.
    ///
    /// - Parameter unit: The StoreKit2 subscription period unit to convert.
    ///
    /// - Note: Unrecognized values from future StoreKit versions map to ``undefined``.
    public init(_ unit: Product.SubscriptionPeriod.Unit) {
        switch unit {
        case .day:
            self = .day
        case .month:
            self = .month
        case .week:
            self = .week
        case .year:
            self = .year
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the period unit.
    ///
    /// - Returns: A lowercase string such as `"day"`, `"week"`, `"month"`, `"year"`,
    ///   or `"undefined"` for unrecognized values.
    public var description: String {
        switch self {
        case .day:
            "day"
        case .month:
            "month"
        case .week:
            "week"
        case .year:
            "year"
        case .undefined:
            "undefined"
        }
    }
}

/// An Objective-C compatible representation of a subscription's billing period.
///
/// Wraps `Product.SubscriptionPeriod` from StoreKit2, exposing the period's value and unit
/// as `@objc`-accessible properties for use in Objective-C codebases.
///
/// A subscription period combines a numeric ``value`` with a ``unit`` to describe
/// how often a subscription renews (e.g., 1 month, 3 months, 1 year).
@objc
public class IAPSubscriptionPeriod: NSObject {
    /// The underlying StoreKit2 subscription period.
    let period: Product.SubscriptionPeriod

    // MARK: Public Properties

    // MARK: - -

    /// The number of units in this subscription period.
    ///
    /// For example, a value of `3` combined with a ``unit`` of ``IAPSubscriptionPeriodUnit/month``
    /// represents a 3-month subscription period.
    @objc public let value: Int

    /// The time unit of this subscription period.
    ///
    /// Indicates whether the period is measured in days, weeks, months, or years.
    @objc public let unit: IAPSubscriptionPeriodUnit

    // MARK: Init

    // MARK: - -

    /// Creates a subscription period from a StoreKit2 `Product.SubscriptionPeriod`.
    ///
    /// - Parameter fromPeriod: The StoreKit2 subscription period to wrap.
    init(_ fromPeriod: Product.SubscriptionPeriod) {
        self.period = fromPeriod

        self.value = self.period.value
        self.unit = IAPSubscriptionPeriodUnit(self.period.unit)
    }
}
