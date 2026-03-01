//
//  IAPProduct.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

/// An Objective-C compatible enumeration representing the type of an in-app purchase product.
///
/// Wraps `StoreKit.Product.ProductType` to expose product type information to Objective-C code.
/// Each case maps directly to the corresponding StoreKit product type.
///
/// - Note: The `undefined` case is used as a fallback for unknown or future StoreKit values
///   that do not match any known product type.
@objc
public enum IAPProductType: Int, CustomStringConvertible {
    /// A fallback value representing an unknown or unsupported product type.
    case undefined = 0

    /// A consumable in-app purchase that can be bought multiple times.
    case consumable

    /// A non-consumable in-app purchase that is bought once and persists permanently.
    case nonConsumable

    /// A non-renewing subscription that grants access for a fixed duration.
    case nonRenewable

    /// An auto-renewable subscription that renews automatically at the end of each billing period.
    case autoRenewable

    /// Creates an `IAPProductType` from a StoreKit `Product.ProductType`.
    ///
    /// - Parameter productType: The StoreKit product type to convert.
    public init(_ productType: Product.ProductType) {
        switch productType {
        case .consumable:
            self = .consumable
        case .nonConsumable:
            self = .nonConsumable
        case .nonRenewable:
            self = .nonRenewable
        case .autoRenewable:
            self = .autoRenewable
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the product type.
    public var description: String {
        switch self {
        case .consumable:
            "consumable"
        case .nonConsumable:
            "nonConsumable"
        case .nonRenewable:
            "nonRenewable"
        case .autoRenewable:
            "autoRenewable"
        case .undefined:
            "undefined"
        }
    }
}

/// An Objective-C compatible enumeration representing the payment mode of a subscription offer.
///
/// Wraps `StoreKit.Product.SubscriptionOffer.PaymentMode` and
/// `StoreKit.Transaction.Offer.PaymentMode` to expose payment mode information to Objective-C code.
///
/// - Note: The `undefined` case is used as a fallback for unknown or future StoreKit values
///   that do not match any known payment mode.
@objc
public enum IAPPaymentMode: Int, LosslessStringConvertible {
    /// A fallback value representing an unknown or unsupported payment mode.
    case undefined = 0

    /// A free trial offer where no payment is charged during the trial period.
    case freeTrial

    /// A pay-as-you-go offer where the discounted price is charged each billing period.
    case payAsYouGo

    /// A pay-up-front offer where the full discounted price is charged at the start.
    case payUpFront

    /// Creates an `IAPPaymentMode` from a StoreKit `Transaction.Offer.PaymentMode`.
    ///
    /// - Parameter paymentMode: The transaction offer payment mode to convert, or `nil`.
    ///
    /// - Note: Available on iOS 17.2+, macOS 14.2+, tvOS 17.2+, watchOS 10.2+, visionOS 1.1+.
    @available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *)
    public init(_ paymentMode: Transaction.Offer.PaymentMode?) {
        switch paymentMode {
        case .freeTrial:
            self = .freeTrial
        case .payAsYouGo:
            self = .payAsYouGo
        case .payUpFront:
            self = .payUpFront
        default:
            self = .undefined
        }
    }

    /// Creates an `IAPPaymentMode` from a StoreKit `Product.SubscriptionOffer.PaymentMode`.
    ///
    /// - Parameter paymentMode: The subscription offer payment mode to convert.
    public init(_ paymentMode: Product.SubscriptionOffer.PaymentMode) {
        switch paymentMode {
        case .freeTrial:
            self = .freeTrial
        case .payAsYouGo:
            self = .payAsYouGo
        case .payUpFront:
            self = .payUpFront
        default:
            self = .undefined
        }
    }

    /// Creates an `IAPPaymentMode` from a snake_case string representation.
    ///
    /// Supported string values (case-insensitive):
    /// - `"free_trial"` maps to `.freeTrial`
    /// - `"pay_as_you_go"` maps to `.payAsYouGo`
    /// - `"pay_up_front"` maps to `.payUpFront`
    ///
    /// - Parameter description: A snake_case string representing the payment mode.
    public init(_ description: String) {
        switch description.lowercased() {
        case "free_trial":
            self = .freeTrial
        case "pay_as_you_go":
            self = .payAsYouGo
        case "pay_up_front":
            self = .payUpFront
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the payment mode.
    public var description: String {
        switch self {
        case .freeTrial:
            "freeTrial"
        case .payAsYouGo:
            "payAsYouGo"
        case .payUpFront:
            "payUpFront"
        case .undefined:
            "undefined"
        }
    }
}

/// An Objective-C compatible enumeration representing the result of an in-app purchase attempt.
///
/// Wraps `StoreKit.Product.PurchaseResult` to expose purchase result information to Objective-C code.
///
/// - Note: The `undefined` case is used as a fallback for unknown or future StoreKit values
///   that do not match any known purchase result.
@objc
public enum IAPPurchaseResult: Int {
    /// A fallback value representing an unknown or unsupported purchase result.
    case undefined = 0

    /// The purchase completed successfully and the transaction has been verified.
    case success

    /// The user cancelled the purchase before it completed.
    case userCancelled

    /// The purchase is pending external action, such as parental approval via Ask to Buy.
    case pending

    /// Creates an `IAPPurchaseResult` from a StoreKit `Product.PurchaseResult`.
    ///
    /// - Parameter purchaseResult: The StoreKit purchase result to convert.
    public init(_ purchaseResult: Product.PurchaseResult) {
        switch purchaseResult {
        case .success:
            self = .success
        case .userCancelled:
            self = .userCancelled
        case .pending:
            self = .pending
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the purchase result.
    public var description: String {
        switch self {
        case .success:
            "success"
        case .userCancelled:
            "userCancelled"
        case .pending:
            "pending"
        case .undefined:
            "undefined"
        }
    }
}

/// An Objective-C compatible wrapper around StoreKit's `Product` type.
///
/// `IAPProduct` exposes product metadata, pricing, subscription information, and purchase
/// functionality to both Swift and Objective-C code. It bridges the gap between StoreKit2's
/// Swift-native `Product` type and Objective-C consumers via `@objc` annotations.
///
/// Use ``products(for:)`` to fetch products from the App Store, then call ``purchase()``
/// or ``purchase(confirmIn:)`` to initiate a purchase flow.
@objc
public class IAPProduct: NSObject {
    /// The underlying StoreKit `Product` instance.
    let product: Product

    // MARK: Public Properies

    // MARK: - -

    /// The unique product identifier string configured in App Store Connect.
    @objc public let productID: String

    /// The type of this product (consumable, non-consumable, non-renewing, or auto-renewable).
    @objc public let type: IAPProductType

    /// The localized display name of the product as configured in App Store Connect.
    @objc public let displayName: String

    /// The localized description of the product as configured in App Store Connect.
    @objc public let productDescription: String

    /// The localized string representation of the product price, including the currency symbol.
    @objc public let displayPrice: String

    /// The decimal value of the product price in the user's local currency.
    @objc public let price: Decimal

    /// The subscription information for this product, or `nil` if the product is not a subscription.
    ///
    /// - Note: This property is only populated for products of type `.nonRenewable` or `.autoRenewable`.
    @objc public let subscription: IAPSubscriptionInfo?

    /// A Boolean value that indicates whether this product is available for Family Sharing.
    @objc public let isFamilyShareable: Bool

    // MARK: Init

    // MARK: - --

    /// Creates an `IAPProduct` from a StoreKit `Product`.
    ///
    /// - Parameter fromProduct: The StoreKit `Product` instance to wrap.
    init(_ fromProduct: Product) {
        self.product = fromProduct

        self.productID = self.product.id
        self.type = IAPProductType(self.product.type)
        self.displayName = self.product.displayName
        self.productDescription = self.product.description
        self.displayPrice = self.product.displayPrice
        self.price = self.product.price

        if let subscription = self.product.subscription {
            self.subscription = IAPSubscriptionInfo(subscription)
        } else {
            self.subscription = nil
        }

        self.isFamilyShareable = self.product.isFamilyShareable
    }

    // MARK: Overridden

    // MARK: - -

    /// A detailed textual representation of the product, including all public properties.
    ///
    /// - Returns: A multi-line string containing the product ID, type, display name,
    ///   description, display price, price, and subscription info.
    override public var description: String {
        var description = super.description + "\n"

        description += "productID: \(self.productID) \n"
        description += "type: \(self.type) \n"
        description += "displayName: \(self.displayName) \n"
        description += "productDescription: \(self.productDescription) \n"
        description += "displayPrice: \(self.displayPrice) \n"
        description += "price: \(self.price) \n"
        description += "subscription: \(String(describing: self.subscription)) \n"

        return description
    }

    // MARK: Public

    // MARK: - --

    /// Fetches in-app purchase products from the App Store for the given product identifiers.
    ///
    /// This method wraps `StoreKit.Product.products(for:)` and converts the returned
    /// `Product` instances into `IAPProduct` objects.
    ///
    /// - Parameter identifiers: An array of product identifier strings configured in App Store Connect.
    /// - Returns: An array of `IAPProduct` objects matching the given identifiers, or `nil` if no products are found.
    /// - Throws: An error if the App Store request fails (e.g., network issues or invalid identifiers).
    @objc
    public static func products(for identifiers: [String]) async throws -> [IAPProduct]? {
        do {
            let loadedProducts = try await Product.products(for: identifiers)

            var products: [IAPProduct] = []
            for loadedProduct in loadedProducts {
                products.append(IAPProduct(loadedProduct))
            }

            return products

        } catch {
            throw error
        }
    }

    /// Initiates a purchase of this product.
    ///
    /// On success, the transaction is automatically verified and finished before being returned.
    ///
    /// - Returns: A tuple containing the verified ``IAPTransaction`` (or `nil` if the purchase did not
    ///   succeed) and the ``IAPPurchaseResult`` indicating the outcome.
    /// - Throws: An error if the purchase request fails (e.g., StoreKit errors or network issues).
    ///
    /// - Note: The transaction is automatically finished on success. Do not call `finish()` again.
    @objc
    public func purchase() async throws -> (IAPTransaction?, IAPPurchaseResult) {
        let purchaseResult = try await self.product.purchase()

        return await self.processPurchaseResult(purchaseResult)
    }

    #if os(iOS)
    /// Initiates a purchase of this product, presenting the purchase confirmation in the specified scene.
    ///
    /// This method is the same as ``purchase()`` but allows specifying a `UIScene` for the
    /// purchase confirmation dialog, which is required on iOS 17+ for proper scene-based presentation.
    ///
    /// On success, the transaction is automatically verified and finished before being returned.
    ///
    /// - Parameter scene: The `UIScene` in which to present the purchase confirmation UI.
    /// - Returns: A tuple containing the verified ``IAPTransaction`` (or `nil` if the purchase did not
    ///   succeed) and the ``IAPPurchaseResult`` indicating the outcome.
    /// - Throws: An error if the purchase request fails (e.g., StoreKit errors or network issues).
    ///
    /// - Note: Available on iOS 17.0+, tvOS 17.0+, and visionOS 1.0+ only.
    ///   The transaction is automatically finished on success.
    @available(iOS 17.0, tvOS 17.0, visionOS 1.0, *)
    @objc
    public func purchase(confirmIn scene: UIScene) async throws -> (IAPTransaction?, IAPPurchaseResult) {
        let purchaseResult = try await self.product.purchase(confirmIn: scene)

        return await self.processPurchaseResult(purchaseResult)
    }
    #endif

    /// Retrieves the current entitlement transaction for this product, if the user is currently entitled.
    ///
    /// Wraps `StoreKit.Product.currentEntitlement` to check whether the user currently has
    /// an active entitlement for this product. For subscriptions, this reflects the active
    /// subscription status. For non-consumables, this reflects whether the product has been purchased.
    ///
    /// - Returns: An ``IAPTransaction`` representing the current entitlement, or `nil` if the user
    ///   is not currently entitled to this product or if verification fails.
    @objc
    public func currentEntitlement() async -> IAPTransaction? {
        let verificationResult: VerificationResult? = await self.product.currentEntitlement
        guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
            return nil
        }

        return transaction
    }

    /// Retrieves the latest transaction for this product.
    ///
    /// Wraps `StoreKit.Product.latestTransaction` to fetch the most recent transaction
    /// associated with this product, regardless of whether the user is currently entitled.
    ///
    /// - Returns: An ``IAPTransaction`` representing the latest transaction, or `nil` if no
    ///   transaction exists for this product or if verification fails.
    @objc
    public func latestTransaction() async -> IAPTransaction? {
        let verificationResult: VerificationResult? = await self.product.latestTransaction
        guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
            return nil
        }

        return transaction
    }

    // MARK: Private

    // MARK: - --

    /// Processes a StoreKit `Product.PurchaseResult` into an `IAPTransaction` and `IAPPurchaseResult` tuple.
    ///
    /// On success, the transaction is verified via `IAPTransaction.transaction(fromVerificationResult:)`
    /// and automatically finished before being returned.
    ///
    /// - Parameter purchaseResult: The raw StoreKit purchase result to process.
    /// - Returns: A tuple containing the verified `IAPTransaction` (or `nil`) and the corresponding
    ///   `IAPPurchaseResult`.
    private func processPurchaseResult(_ purchaseResult: Product
        .PurchaseResult) async
        -> (IAPTransaction?, IAPPurchaseResult)
    {
        switch purchaseResult {
        case let .success(verificationResult):
            guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
                return (nil, .undefined)
            }
            await transaction.finish() // Always finish a transaction.
            return (transaction, .success)
        case .userCancelled:
            return (nil, .userCancelled)
        case .pending:
            return (nil, .pending)
        default:
            return (nil, .undefined)
        }
    }
}
