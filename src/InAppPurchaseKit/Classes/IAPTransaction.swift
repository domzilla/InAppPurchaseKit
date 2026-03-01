//
//  IAPTransaction.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 03.06.24.
//

import Foundation
import StoreKit

/// Objective-C compatible representation of a transaction's ownership type.
///
/// Wraps `StoreKit.Transaction.OwnershipType` to indicate whether a transaction
/// was purchased directly by the user or shared via Family Sharing.
@objc
public enum IAPTransactionOwnershipType: Int, CustomStringConvertible {
    /// A fallback value used when the ownership type is unknown or cannot be mapped.
    case undefined = 0

    /// The transaction was shared with the user through Family Sharing.
    case familyShared

    /// The transaction was purchased directly by the user.
    case purchased

    /// Creates an ownership type from a StoreKit `Transaction.OwnershipType`.
    ///
    /// - Parameter ownershipType: The StoreKit ownership type to convert, or `nil`.
    ///   Passing `nil` or an unrecognized value results in ``undefined``.
    public init(_ ownershipType: Transaction.OwnershipType?) {
        switch ownershipType {
        case .familyShared:
            self = .familyShared
        case .purchased:
            self = .purchased
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the ownership type.
    public var description: String {
        switch self {
        case .familyShared:
            "familyShared"
        case .purchased:
            "purchased"
        case .undefined:
            "undefined"
        }
    }
}

/// Objective-C compatible representation of a transaction's reason.
///
/// Wraps `StoreKit.Transaction.Reason` to indicate whether a transaction
/// originated from a direct purchase or an automatic subscription renewal.
///
/// - Note: The StoreKit `Transaction.Reason` type requires iOS 17.0+ / macOS 14.0+.
///   On earlier platforms, the reason is parsed from the transaction's string representation.
@objc
public enum IAPTransactionReason: Int, LosslessStringConvertible {
    /// A fallback value used when the reason is unknown or cannot be mapped.
    case undefined = 0

    /// The transaction resulted from a direct purchase by the user.
    case purchase

    /// The transaction resulted from an automatic subscription renewal.
    case renewal

    /// Creates a transaction reason from a StoreKit `Transaction.Reason`.
    ///
    /// - Parameter reason: The StoreKit transaction reason to convert, or `nil`.
    ///   Passing `nil` or an unrecognized value results in ``undefined``.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(_ reason: Transaction.Reason?) {
        switch reason {
        case .purchase:
            self = .purchase
        case .renewal:
            self = .renewal
        default:
            self = .undefined
        }
    }

    /// Creates a transaction reason from its string representation.
    ///
    /// This initializer is used as a fallback on platforms where `Transaction.Reason`
    /// is not available (prior to iOS 17.0 / macOS 14.0). The comparison is case-insensitive.
    ///
    /// - Parameter description: A string representation of the transaction reason
    ///   (e.g., `"purchase"` or `"renewal"`). Unrecognized strings result in ``undefined``.
    public init(_ description: String) {
        switch description.lowercased() {
        case "purchase":
            self = .purchase
        case "renewal":
            self = .renewal
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the transaction reason.
    public var description: String {
        switch self {
        case .purchase:
            "purchase"
        case .renewal:
            "renewal"
        case .undefined:
            "undefined"
        }
    }
}

/// Objective-C compatible representation of a transaction's revocation reason.
///
/// Wraps `StoreKit.Transaction.RevocationReason` to indicate why Apple revoked
/// a previously granted transaction.
@objc
public enum IAPRevocationReason: Int, CustomStringConvertible {
    /// A fallback value used when the revocation reason is unknown or cannot be mapped.
    case undefined = 0

    /// The transaction was revoked due to an issue caused by the developer
    /// (e.g., the customer did not receive the promised content).
    case developerIssue

    /// The transaction was revoked for another reason not related to a developer issue.
    case other

    /// Creates a revocation reason from a StoreKit `Transaction.RevocationReason`.
    ///
    /// - Parameter revocationReason: The StoreKit revocation reason to convert, or `nil`.
    ///   Passing `nil` or an unrecognized value results in ``undefined``.
    public init(_ revocationReason: Transaction.RevocationReason?) {
        switch revocationReason {
        case .developerIssue:
            self = .developerIssue
        case .other:
            self = .other
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the revocation reason.
    public var description: String {
        switch self {
        case .developerIssue:
            "developerIssue"
        case .other:
            "other"
        case .undefined:
            "undefined"
        }
    }
}

/// Objective-C compatible representation of a refund request's status.
///
/// Wraps `StoreKit.Transaction.RefundRequestStatus` to indicate the outcome
/// of a refund request initiated by the user.
@objc
public enum IAPRefundRequestStatus: Int, CustomStringConvertible {
    /// A fallback value used when the refund request status is unknown or cannot be mapped.
    case undefined = 0

    /// The user canceled the refund request before it was submitted.
    case userCanceled

    /// The refund request was successfully submitted to Apple.
    case success

    /// Creates a refund request status from a StoreKit `Transaction.RefundRequestStatus`.
    ///
    /// - Parameter status: The StoreKit refund request status to convert, or `nil`.
    ///   Passing `nil` or an unrecognized value results in ``undefined``.
    public init(_ status: Transaction.RefundRequestStatus?) {
        switch status {
        case .userCancelled:
            self = .userCanceled
        case .success:
            self = .success
        default:
            self = .undefined
        }
    }

    /// A human-readable string representation of the refund request status.
    public var description: String {
        switch self {
        case .userCanceled:
            "userCanceled"
        case .success:
            "success"
        case .undefined:
            "undefined"
        }
    }
}

/// Objective-C compatible wrapper around StoreKit's `Transaction`.
///
/// Provides access to all transaction properties and static methods for querying
/// the user's transaction history, current entitlements, and managing transaction
/// lifecycle (finishing, refund requests).
///
/// This class bridges StoreKit2's Swift-only `Transaction` type to Objective-C
/// by extending `NSObject` and annotating all public members with `@objc`.
///
/// - Note: Only verified transactions are surfaced through this class. Unverified
///   transactions are silently discarded with a debug log message.
@objc
public class IAPTransaction: NSObject {
    /// The underlying StoreKit `Transaction` that this instance wraps.
    let transaction: Transaction

    // MARK: Public Properties

    // MARK: - --

    /// Notification posted when a transaction is finished via ``finish()``.
    ///
    /// The notification's `object` is the `IAPTransaction` instance that was finished.
    /// Observe this notification to react to transaction completion events across your app.
    @objc public static let TransactionDidFinishNotification = NSNotification
        .Name("IAPTransactionDidFinishNotification")

    /// The App Store environment in which the transaction occurred (e.g., sandbox, production).
    @objc public let environment: IAPAppStoreEnvironment

    /// The date of the original purchase for this transaction.
    ///
    /// For renewals, this is the date of the very first purchase in the subscription chain.
    @objc public let originalPurchaseDate: Date

    /// The original transaction identifier.
    ///
    /// This identifier remains the same across renewals for a given subscription.
    @objc public let originalTransactionID: UInt64

    /// The unique identifier for this specific transaction.
    @objc public let transactionID: UInt64

    /// The web order line item identifier, if available.
    ///
    /// This value is populated for transactions that originate from a web-based purchase flow.
    @objc public let webOrderLineItemID: String?

    /// The bundle identifier of the app that the transaction belongs to.
    @objc public let appBundleID: String

    /// The product identifier associated with this transaction.
    @objc public let productID: String

    /// The type of product associated with this transaction (e.g., consumable, auto-renewable subscription).
    @objc public let productType: IAPProductType

    /// The subscription group identifier, if the product is a subscription.
    ///
    /// Returns `nil` for non-subscription products.
    @objc public let subscriptionGroupID: String?

    /// The date when this specific transaction's purchase was made.
    @objc public let purchaseDate: Date

    /// The expiration date of the subscription, if applicable.
    ///
    /// Returns `nil` for non-subscription products or subscriptions that do not expire.
    @objc public let expirationDate: Date?

    /// Whether this transaction has been superseded by a higher-level subscription in the same group.
    ///
    /// When `true`, the user has upgraded to a different subscription and this transaction's
    /// entitlement should no longer be honored.
    @objc public let isUpgraded: Bool

    /// The ownership type of this transaction, indicating whether it was purchased directly
    /// or shared via Family Sharing.
    @objc public let ownershipType: IAPTransactionOwnershipType

    /// The quantity of items purchased in this transaction.
    ///
    /// For consumable products, this may be greater than 1. For other product types, it is typically 1.
    @objc public let purchasedQuantity: Int

    /// The reason for this transaction (e.g., a direct purchase or an automatic renewal).
    ///
    /// - Note: On iOS versions prior to 17.0 / macOS 14.0, this is parsed from the
    ///   transaction's string representation as a fallback.
    @objc public let reason: IAPTransactionReason

    /// The promotional or introductory offer applied to this transaction, if any.
    ///
    /// Returns `nil` if no offer was applied.
    @objc public let offer: IAPOffer?

    /// The date when Apple revoked this transaction, if applicable.
    ///
    /// Returns `nil` if the transaction has not been revoked.
    @objc public let revocationDate: Date?

    /// The reason why Apple revoked this transaction, if applicable.
    ///
    /// Returns ``IAPRevocationReason/undefined`` if the transaction has not been revoked.
    @objc public let revocationReason: IAPRevocationReason

    /// The UUID that the app supplied when the user made the purchase, if any.
    ///
    /// This can be used to associate the transaction with a user account on your server.
    @objc public let appAccountToken: UUID?

    /// The ISO 4217 currency code for the transaction's price.
    ///
    /// On iOS 16.0+ / macOS 13.0+, this uses the `currency.identifier` property.
    /// On earlier platforms, it falls back to the deprecated `currencyCode` property.
    ///
    /// Returns `nil` if the currency information is unavailable.
    @objc public var currencyCode: String? {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            self.transaction.currency?.identifier
        } else {
            self.transaction.currencyCode
        }
    }

    /// The price of the product at the time of purchase.
    ///
    /// Returns `0` if the price is unavailable (e.g., for promoted or restored transactions
    /// where price information is not present).
    @objc public var price: Decimal {
        guard let price = self.transaction.price else {
            return 0
        }
        return price
    }

    // MARK: Init

    // MARK: - --

    /// Creates an `IAPTransaction` wrapper from a StoreKit `Transaction`.
    ///
    /// All properties are eagerly extracted from the StoreKit transaction at initialization time.
    /// Platform-specific availability checks are applied for properties like ``environment``
    /// and ``reason`` to use the best available API.
    ///
    /// - Parameter fromTransaction: The verified StoreKit `Transaction` to wrap.
    init(_ fromTransaction: Transaction) {
        self.transaction = fromTransaction

        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            self.environment = IAPAppStoreEnvironment(self.transaction.environment)
        } else {
            self.environment = IAPAppStoreEnvironment(self.transaction.environmentStringRepresentation)
        }

        self.originalPurchaseDate = self.transaction.originalPurchaseDate
        self.originalTransactionID = self.transaction.originalID
        self.transactionID = self.transaction.id
        self.webOrderLineItemID = self.transaction.webOrderLineItemID
        self.appBundleID = self.transaction.appBundleID
        self.productID = self.transaction.productID
        self.productType = IAPProductType(self.transaction.productType)
        self.subscriptionGroupID = self.transaction.subscriptionGroupID
        self.purchaseDate = self.transaction.purchaseDate
        self.expirationDate = self.transaction.expirationDate
        self.isUpgraded = self.transaction.isUpgraded
        self.ownershipType = IAPTransactionOwnershipType(self.transaction.ownershipType)
        self.purchasedQuantity = self.transaction.purchasedQuantity

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self.reason = IAPTransactionReason(self.transaction.reason)
        } else {
            self.reason = IAPTransactionReason(self.transaction.reasonStringRepresentation)
        }

        self.offer = IAPOffer.fromTransaction(self.transaction)
        self.revocationDate = self.transaction.revocationDate
        self.revocationReason = IAPRevocationReason(self.transaction.revocationReason)
        self.appAccountToken = self.transaction.appAccountToken
    }

    // MARK: Overridden

    // MARK: - -

    /// A detailed, multi-line string representation of this transaction for debugging purposes.
    ///
    /// Includes all public properties such as environment, product ID, purchase date,
    /// expiration date, ownership type, and more.
    override public var description: String {
        var description = super.description + "\n"

        description += "environment: \(self.environment.description) \n"
        description += "originalPurchaseDate: \(self.originalPurchaseDate) \n"
        description += "originalTransactionID: \(self.originalTransactionID) \n"
        description += "transactionID: \(self.transactionID) \n"
        description += "webOrderLineItemID: \(self.webOrderLineItemID ?? "nil") \n"
        description += "appBundleID: \(self.appBundleID) \n"
        description += "productID: \(self.productID) \n"
        description += "productType: \(self.productType.description) \n"
        description += "subscriptionGroupID: \(self.subscriptionGroupID ?? "nil") \n"
        description += "purchaseDate: \(self.purchaseDate) \n"
        description += "expirationDate: \(String(describing: self.expirationDate)) \n"
        description += "isUpgraded: \(self.isUpgraded) \n"
        description += "ownershipType: \(self.ownershipType.description) \n"
        description += "purchasedQuantity: \(self.purchasedQuantity) \n"
        description += "reason: \(self.reason.description) \n"
        description += "offer: \(String(describing: self.offer)) \n"
        description += "revocationDate: \(String(describing: self.revocationDate)) \n"
        description += "revocationReason: \(self.revocationReason.description) \n"
        description += "appAccountToken: \(String(describing: self.appAccountToken)) \n"
        description += "currencyCode: \(self.currencyCode ?? "nil") \n"
        description += "price: \(self.price) \n"

        return description
    }

    // MARK: Public

    // MARK: - -

    /// Retrieves the current subscription status for this transaction's subscription group.
    ///
    /// - Returns: An ``IAPSubscriptionStatus`` representing the current subscription status,
    ///   or `nil` if this transaction is not associated with a subscription or the status
    ///   cannot be determined.
    @objc
    public func subscriptionStatus() async -> IAPSubscriptionStatus? {
        guard let subscriptionStatus = await self.transaction.subscriptionStatus else {
            return nil
        }

        return IAPSubscriptionStatus(subscriptionStatus)
    }

    /// Retrieves the latest transaction for the specified product.
    ///
    /// Queries StoreKit for the most recent transaction associated with the given product
    /// identifier. Only verified transactions are returned.
    ///
    /// - Parameter productID: The product identifier to query.
    /// - Returns: The latest verified ``IAPTransaction`` for the product, or `nil` if no
    ///   verified transaction exists.
    @objc
    public static func latest(forProductID productID: String) async -> IAPTransaction? {
        let verificationResult = await Transaction.latest(for: productID)

        return IAPTransaction.transaction(fromVerificationResult: verificationResult)
    }

    /// Retrieves the latest transactions for multiple products concurrently.
    ///
    /// Uses a `TaskGroup` to fetch the latest transaction for each product identifier
    /// in parallel. Only verified transactions are included in the result.
    ///
    /// - Parameter productIDs: An array of product identifiers to query.
    /// - Returns: An array of verified ``IAPTransaction`` instances. The order is not
    ///   guaranteed to match the input array. Products without verified transactions
    ///   are omitted from the result.
    @objc
    public static func latest(forProductIDs productIDs: [String]) async -> [IAPTransaction] {
        await withTaskGroup(of: IAPTransaction?.self) { group in
            for productID in productIDs {
                group.addTask {
                    await IAPTransaction.latest(forProductID: productID)
                }
            }

            var latest: [IAPTransaction] = []
            for await transaction in group {
                if let transaction {
                    latest.append(transaction)
                }
            }

            return latest
        }
    }

    /// Retrieves all transactions for the user.
    ///
    /// Iterates through the complete transaction history from StoreKit, including
    /// finished and unfinished transactions. Only verified transactions are included.
    ///
    /// - Returns: An array of all verified ``IAPTransaction`` instances.
    @objc
    public static func all() async -> [IAPTransaction] {
        var all: [IAPTransaction] = []

        for await verificationResult in Transaction.all {
            if let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) {
                all.append(transaction)
            }
        }

        return all
    }

    /// Retrieves all current entitlements for the user.
    ///
    /// Returns the transactions that represent the user's active entitlements.
    /// This includes active subscriptions, non-consumable purchases, and
    /// non-revoked transactions. Only verified transactions are included.
    ///
    /// - Returns: An array of verified ``IAPTransaction`` instances representing
    ///   the user's current entitlements.
    @objc
    public static func currentEntitlements() async -> [IAPTransaction] {
        var currentEntitlements: [IAPTransaction] = []

        for await verificationResult in Transaction.currentEntitlements {
            if let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) {
                currentEntitlements.append(transaction)
            }
        }

        return currentEntitlements
    }

    /// Retrieves the current entitlement for a specific product.
    ///
    /// Queries StoreKit for the user's current entitlement to the specified product.
    /// Only verified transactions are returned.
    ///
    /// - Parameter productID: The product identifier to check entitlement for.
    /// - Returns: The verified ``IAPTransaction`` representing the entitlement,
    ///   or `nil` if the user has no current entitlement to this product.
    @objc
    public static func currentEntitlement(forProductID productID: String) async -> IAPTransaction? {
        let verificationResult = await Transaction.currentEntitlement(for: productID)

        return IAPTransaction.transaction(fromVerificationResult: verificationResult)
    }

    /// Retrieves current entitlements filtered to a specific set of product identifiers.
    ///
    /// Fetches all current entitlements and returns only those whose product identifier
    /// is contained in the provided array.
    ///
    /// - Parameter productIDs: An array of product identifiers to filter by.
    /// - Returns: An array of verified ``IAPTransaction`` instances whose product
    ///   identifiers match the provided list.
    @objc
    public static func currentEntitlements(forProductIDs productIDs: [String]) async -> [IAPTransaction] {
        let currentEntitlements = await IAPTransaction.currentEntitlements()
        return currentEntitlements.filter { entitlement in
            productIDs.contains(entitlement.productID)
        }
    }

    /// Finishes the transaction and posts a notification.
    ///
    /// Calls `finish()` on the underlying StoreKit `Transaction` to acknowledge that
    /// the app has delivered the purchased content, then posts
    /// ``TransactionDidFinishNotification`` with this transaction as the notification object.
    ///
    /// - Note: Always finish transactions after delivering content to the user.
    ///   Unfinished transactions will be re-delivered by StoreKit on subsequent app launches.
    @objc
    public func finish() async {
        await self.transaction.finish()

        NotificationCenter.default.post(name: IAPTransaction.TransactionDidFinishNotification, object: self)
    }

    #if os(iOS)
    /// Presents the system refund request sheet for this transaction.
    ///
    /// Displays the App Store refund request UI in the specified window scene,
    /// allowing the user to request a refund for this purchase.
    ///
    /// - Parameter scene: The `UIWindowScene` in which to present the refund request sheet.
    /// - Returns: An ``IAPRefundRequestStatus`` indicating the outcome of the refund request.
    /// - Throws: An error if the refund request could not be initiated (e.g., network failure
    ///   or the transaction is not eligible for a refund).
    @objc
    public func beginRefundRequest(in scene: UIWindowScene) async throws -> IAPRefundRequestStatus {
        let status = try await self.transaction.beginRefundRequest(in: scene)
        return IAPRefundRequestStatus(status)
    }

    /// Presents the system refund request sheet for a transaction with the specified identifier.
    ///
    /// This is a convenience method that initiates a refund request without needing
    /// an `IAPTransaction` instance. It looks up the transaction by its identifier.
    ///
    /// - Parameter transactionID: The unique identifier of the transaction to request a refund for.
    /// - Parameter scene: The `UIWindowScene` in which to present the refund request sheet.
    /// - Returns: An ``IAPRefundRequestStatus`` indicating the outcome of the refund request.
    /// - Throws: An error if the refund request could not be initiated.
    @objc
    public static func beginRefundRequest(
        for transactionID: UInt64,
        in scene: UIWindowScene
    ) async throws
        -> IAPRefundRequestStatus
    {
        let status = try await Transaction.beginRefundRequest(for: transactionID, in: scene)
        return IAPRefundRequestStatus(status)
    }
    #endif

    /// Creates an ``IAPTransaction`` from a StoreKit verification result, if the transaction is verified.
    ///
    /// This method only returns a transaction for `.verified` results. Unverified transactions
    /// are logged via `debugPrint` and discarded, returning `nil`.
    ///
    /// - Parameter verificationResult: The StoreKit `VerificationResult<Transaction>` to evaluate,
    ///   or `nil`.
    /// - Returns: An ``IAPTransaction`` wrapping the verified transaction, or `nil` if the
    ///   result is unverified or `nil`.
    public static func transaction(fromVerificationResult verificationResult: VerificationResult<Transaction>?)
        -> IAPTransaction?
    {
        switch verificationResult {
        case let .verified(transaction):
            return IAPTransaction(transaction)
        case let .unverified(unverifiedTransaction, verificationError):
            debugPrint("unverifiedTransaction: " + unverifiedTransaction.debugDescription)
            debugPrint("verificationError: " + verificationError.localizedDescription)
            return nil
        case nil:
            return nil
        }
    }
}
