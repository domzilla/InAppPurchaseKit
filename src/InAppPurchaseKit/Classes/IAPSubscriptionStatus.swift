//
//  IAPSubscriptionStatus.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 04.06.24.
//

import Foundation
import StoreKit

/// An Objective-C compatible enum representing the renewal state of an auto-renewable subscription.
///
/// Wraps `Product.SubscriptionInfo.RenewalState` from StoreKit2, providing an `@objc`-accessible
/// integer-backed enum for use in Objective-C codebases.
///
/// Cases are grouped by entitlement: ``subscribed`` and ``inGracePeriod`` indicate the user
/// is entitled to service, while ``expired``, ``inBillingRetryPeriod``, and ``revoked`` indicate
/// the user is not entitled.
@objc
public enum IAPSubscriptionRenewalState: Int, CustomStringConvertible {
    /// A fallback value for unknown or future `Product.SubscriptionInfo.RenewalState` values
    /// that this framework does not yet handle.
    case undefined = 0

    // Entitled for service

    /// The subscription is active and the user is entitled to service.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalState.subscribed`.
    case subscribed

    /// The subscription has expired but the user is still entitled to service
    /// during a billing grace period granted by the App Store.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalState.inGracePeriod`.
    case inGracePeriod

    // Not entitled for service

    /// The subscription has expired and the user is no longer entitled to service.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalState.expired`.
    case expired

    /// The subscription failed to renew due to a billing issue and the App Store
    /// is attempting to recover payment. The user is not entitled to service.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalState.inBillingRetryPeriod`.
    case inBillingRetryPeriod

    /// The subscription was revoked (e.g., via a refund or Family Sharing removal)
    /// and the user is no longer entitled to service.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalState.revoked`.
    case revoked

    /// Creates a renewal state from a StoreKit2 `Product.SubscriptionInfo.RenewalState`.
    ///
    /// - Parameter state: The StoreKit2 renewal state to convert. Pass `nil` to get ``undefined``.
    public init(_ state: Product.SubscriptionInfo.RenewalState?) {
        switch state {
        case .subscribed:
            self = .subscribed
        case .inGracePeriod:
            self = .inGracePeriod
        case .expired:
            self = .expired
        case .inBillingRetryPeriod:
            self = .inBillingRetryPeriod
        case .revoked:
            self = .revoked
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the renewal state.
    public var description: String {
        switch self {
        case .subscribed:
            "subscribed"
        case .inGracePeriod:
            "inGracePeriod"
        case .expired:
            "expired"
        case .inBillingRetryPeriod:
            "inBillingRetryPeriod"
        case .revoked:
            "revoked"
        case .undefined:
            "undefined"
        }
    }
}

/// An Objective-C compatible enum representing the reason a subscription expired.
///
/// Wraps `Product.SubscriptionInfo.RenewalInfo.ExpirationReason` from StoreKit2, providing an
/// `@objc`-accessible integer-backed enum for use in Objective-C codebases.
@objc
public enum IAPSubscriptionExpirationReason: Int, CustomStringConvertible {
    /// The subscription has not expired. This is the default value when there is no expiration reason.
    case none = 0 // not expired

    /// The user disabled auto-renewal for the subscription.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalInfo.ExpirationReason.autoRenewDisabled`.
    case autoRenewDisabled

    /// The subscription expired due to a billing error (e.g., payment method declined).
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalInfo.ExpirationReason.billingError`.
    case billingError

    /// The user did not consent to a price increase for the subscription.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalInfo.ExpirationReason.didNotConsentToPriceIncrease`.
    case didNotConsentToPriceIncrease

    /// The subscription product is no longer available in the App Store.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalInfo.ExpirationReason.productUnavailable`.
    case productUnavailable

    /// The subscription expired for an unknown reason reported by StoreKit.
    ///
    /// Wraps `Product.SubscriptionInfo.RenewalInfo.ExpirationReason.unknown`.
    case unknown

    /// Creates an expiration reason from a StoreKit2 `Product.SubscriptionInfo.RenewalInfo.ExpirationReason`.
    ///
    /// - Parameter expirationReason: The StoreKit2 expiration reason to convert. Pass `nil` to get ``none``.
    init(_ expirationReason: Product.SubscriptionInfo.RenewalInfo.ExpirationReason?) {
        switch expirationReason {
        case .autoRenewDisabled:
            self = .autoRenewDisabled
        case .billingError:
            self = .billingError
        case .didNotConsentToPriceIncrease:
            self = .didNotConsentToPriceIncrease
        case .productUnavailable:
            self = .productUnavailable
        case .unknown:
            self = .unknown
        default:
            self = .none
        }
    }

    /// A human-readable string representation of the expiration reason.
    public var description: String {
        switch self {
        case .autoRenewDisabled:
            "autoRenewDisabled"
        case .billingError:
            "billingError"
        case .didNotConsentToPriceIncrease:
            "didNotConsentToPriceIncrease"
        case .productUnavailable:
            "productUnavailable"
        case .unknown:
            "unknown"
        case .none:
            "none"
        }
    }
}

/// An Objective-C compatible wrapper around StoreKit2's `Product.SubscriptionInfo.Status`.
///
/// Provides access to a subscription's renewal state, associated transaction, auto-renewal status,
/// expiration reason, renewal date, and grace period expiration date. All properties are exposed
/// as `@objc` for Objective-C bridging.
///
/// Instances are created internally from a `Product.SubscriptionInfo.Status` and are typically
/// obtained by calling ``IAPTransaction/subscriptionStatus()`` on a subscription transaction.
///
/// - Note: Renewal info is only available when StoreKit verification succeeds. If verification
///   fails, renewal-dependent properties (``willAutoRenew``, ``expirationReason``, ``renewalDate``,
///   ``gracePeriodExpirationDate``) return their default/fallback values.
@objc
public class IAPSubscriptionStatus: NSObject {
    /// The underlying StoreKit2 subscription status.
    let status: Product.SubscriptionInfo.Status

    /// The verified renewal info extracted from the status, or `nil` if verification failed.
    let renewalInfo: Product.SubscriptionInfo.RenewalInfo?

    // MARK: Public Properties

    // MARK: - --

    /// The current renewal state of the subscription (e.g., subscribed, expired, revoked).
    ///
    /// Derived from `Product.SubscriptionInfo.Status.state`.
    @objc public let state: IAPSubscriptionRenewalState

    /// The transaction associated with this subscription status, or `nil` if transaction verification failed.
    ///
    /// Contains purchase details such as the product ID, purchase date, and expiration date.
    @objc public let transaction: IAPTransaction?

    /// A Boolean value indicating whether the subscription will automatically renew at the end
    /// of the current billing period.
    ///
    /// Returns `false` if renewal info is unavailable (i.e., verification failed).
    @objc public var willAutoRenew: Bool {
        guard let renewalInfo = self.renewalInfo else {
            return false
        }
        return renewalInfo.willAutoRenew
    }

    /// The reason the subscription expired, or ``IAPSubscriptionExpirationReason/none`` if
    /// the subscription has not expired.
    ///
    /// Returns ``IAPSubscriptionExpirationReason/none`` if renewal info is unavailable.
    @objc public var expirationReason: IAPSubscriptionExpirationReason {
        IAPSubscriptionExpirationReason(self.renewalInfo?.expirationReason)
    }

    /// The date when the subscription is expected to renew, or `nil` if renewal info is unavailable.
    @objc public var renewalDate: Date? {
        self.renewalInfo?.renewalDate
    }

    /// The date when the billing grace period expires, or `nil` if the subscription
    /// is not in a grace period or renewal info is unavailable.
    @objc public var gracePeriodExpirationDate: Date? {
        self.renewalInfo?.gracePeriodExpirationDate
    }

    // MARK: Init

    // MARK: - --

    /// Creates a subscription status wrapper from a StoreKit2 `Product.SubscriptionInfo.Status`.
    ///
    /// Extracts the renewal state, transaction, and renewal info from the provided status.
    /// If the renewal info fails StoreKit verification, it is discarded and renewal-dependent
    /// properties will return their default values.
    ///
    /// - Parameter fromStatus: The StoreKit2 subscription status to wrap.
    init(_ fromStatus: Product.SubscriptionInfo.Status) {
        self.status = fromStatus

        self.state = IAPSubscriptionRenewalState(self.status.state)
        self.transaction = IAPTransaction.transaction(fromVerificationResult: self.status.transaction)

        switch self.status.renewalInfo {
        case let .verified(renewalInfo):
            self.renewalInfo = renewalInfo
        case let .unverified(unverifiedRenewalInfo, verificationError):
            debugPrint("unverifiedRenewalInfo: " + unverifiedRenewalInfo.debugDescription)
            debugPrint("verificationError: " + verificationError.localizedDescription)
            self.renewalInfo = nil
        }
    }

    // MARK: Overridden

    // MARK: - -

    /// A detailed, multi-line string representation of the subscription status.
    ///
    /// Includes the renewal state, auto-renewal flag, expiration reason, renewal date,
    /// and grace period expiration date.
    override public var description: String {
        var description = super.description + "\n"

        description += "state: \(self.state.description) \n"
        description += "willAutoRenew: \(self.willAutoRenew) \n"
        description += "expirationReason: \(self.expirationReason.description) \n"
        description += "renewalDate: \(String(describing: self.renewalDate)) \n"
        description += "gracePeriodExpirationDate: \(String(describing: self.gracePeriodExpirationDate)) \n"

        return description
    }
}
