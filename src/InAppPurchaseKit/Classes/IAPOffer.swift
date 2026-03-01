//
//  IAPOffer.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 04.06.24.
//

import Foundation
import StoreKit

/// An Objective-C compatible enumeration representing the type of offer applied to a transaction.
///
/// Wraps `Transaction.OfferType` from StoreKit2, mapping each case to an integer-backed
/// `@objc` enum so it can be consumed from Objective-C code.
///
/// - Note: The ``undefined`` case serves as a fallback for unknown or future StoreKit values
///   that this wrapper does not yet handle.
@objc
public enum IAPOfferType: Int, CustomStringConvertible {
    /// A fallback value indicating an unknown or unsupported offer type.
    case undefined = 0

    /// An introductory offer for new subscribers.
    ///
    /// Corresponds to `Transaction.OfferType.introductory`.
    case introductory

    /// A promotional offer targeting eligible existing or lapsed subscribers.
    ///
    /// Corresponds to `Transaction.OfferType.promotional`.
    case promotional

    /// An offer redeemed via a subscription offer code.
    ///
    /// Corresponds to `Transaction.OfferType.code`.
    case code

    /// Creates an ``IAPOfferType`` from a StoreKit `Transaction.OfferType`.
    ///
    /// - Parameter offerType: The StoreKit offer type to convert. Pass `nil` to receive ``undefined``.
    public init(_ offerType: Transaction.OfferType?) {
        switch offerType {
        case .introductory:
            self = .introductory
        case .promotional:
            self = .promotional
        case .code:
            self = .code
        default:
            self = .undefined
        }
    }

    /// A human-readable string describing this offer type.
    public var description: String {
        switch self {
        case .introductory:
            "introductory"
        case .promotional:
            "promotional"
        case .code:
            "code"
        case .undefined:
            "undefined"
        }
    }
}

/// An Objective-C compatible representation of offer information associated with a StoreKit2 transaction.
///
/// `IAPOffer` captures the offer identifier, type, and payment mode that were applied when a
/// transaction was originally processed. It is typically created via ``fromTransaction(_:)``
/// and stored on ``IAPTransaction/offer``.
///
/// This class also serves as the base class for ``IAPSubscriptionOffer``, which adds
/// price and period details available on `Product.SubscriptionOffer`.
///
/// - Note: Wraps offer data from `Transaction.Offer` (iOS 17.2+) or the legacy
///   `Transaction` offer properties on earlier OS versions.
@objc
public class IAPOffer: NSObject {
    // MARK: Public Properties

    // MARK: - --

    /// The identifier of the offer that was applied to the transaction, if any.
    ///
    /// For promotional and code offers this corresponds to the offer ID configured in
    /// App Store Connect. Introductory offers typically have a `nil` identifier.
    @objc public let offerID: String?

    /// The type of offer that was applied to the transaction.
    ///
    /// Indicates whether the offer was introductory, promotional, or a subscription offer code.
    /// See ``IAPOfferType`` for possible values.
    @objc public let type: IAPOfferType

    /// The payment mode of the offer, describing how the user is charged during the offer period.
    ///
    /// Common modes include pay-as-you-go, pay-up-front, and free trial.
    /// See ``IAPPaymentMode`` for possible values.
    @objc public let paymentMode: IAPPaymentMode

    // MARK: Init

    // MARK: - --

    /// Creates an ``IAPOffer`` with the given offer details.
    ///
    /// - Parameter offerID: The identifier of the applied offer, or `nil` if not applicable.
    /// - Parameter type: The type of the offer (introductory, promotional, or code).
    /// - Parameter paymentMode: The payment mode describing how the offer charges the user.
    @objc
    public init(offerID: String?, type: IAPOfferType, paymentMode: IAPPaymentMode) {
        self.offerID = offerID
        self.type = type
        self.paymentMode = paymentMode
    }

    /// Creates an ``IAPOffer`` from a StoreKit `Transaction`, extracting the applied offer information.
    ///
    /// On iOS 17.2+ / macOS 14.2+ this reads from `Transaction.offer`. On earlier OS versions
    /// it falls back to the deprecated `offerID`, `offerType`, and
    /// `offerPaymentModeStringRepresentation` properties.
    ///
    /// - Parameter transaction: The StoreKit `Transaction` to extract offer data from.
    /// - Returns: An ``IAPOffer`` instance if the transaction has an associated offer, or `nil`
    ///   if no offer was applied.
    public static func fromTransaction(_ transaction: Transaction) -> IAPOffer? {
        let id: String?
        let type: IAPOfferType
        let paymentMode: IAPPaymentMode

        if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *) {
            guard let offer = transaction.offer else {
                return nil
            }

            id = offer.id
            type = IAPOfferType(offer.type)
            paymentMode = IAPPaymentMode(offer.paymentMode)
        } else {
            id = transaction.offerID
            type = IAPOfferType(transaction.offerType)
            if let offerPaymentModeStringRepresentation = transaction.offerPaymentModeStringRepresentation {
                paymentMode = IAPPaymentMode(offerPaymentModeStringRepresentation)
            } else {
                paymentMode = .undefined
            }
        }

        return IAPOffer(offerID: id, type: type, paymentMode: paymentMode)
    }

    // MARK: Overridden

    // MARK: - -

    /// A textual representation of the offer, listing the offer ID, type, and payment mode.
    override public var description: String {
        var description = super.description + "\n"

        description += "offerID: \(self.offerID ?? "nil") \n"
        description += "type: \(self.type.description) \n"
        description += "paymentMode: \(self.paymentMode.description) \n"

        return description
    }
}
