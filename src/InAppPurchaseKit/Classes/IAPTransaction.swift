//
//  IAPTransaction.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 03.06.24.
//

import Foundation
import StoreKit

@objc public enum IAPTransactionOwnershipType: Int, CustomStringConvertible {
    case undefined = 0
    
    case familyShared
    case purchased
    
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
    
    public var description: String {
        switch self {
        case .familyShared:
            return "familyShared"
        case .purchased:
            return "purchased"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public enum IAPTransactionReason: Int, LosslessStringConvertible {
    case undefined = 0
    
    case purchase
    case renewal
    
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
    
    public var description: String {
        switch self {
        case .purchase:
            return "purchase"
        case .renewal:
            return "renewal"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public enum IAPRevocationReason: Int, CustomStringConvertible {
    case undefined = 0
    
    case developerIssue
    case other
    
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
    
    public var description: String {
        switch self {
        case .developerIssue:
            return "developerIssue"
        case .other:
            return "other"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public enum IAPRefundRequestStatus: Int, CustomStringConvertible {
    case undefined = 0
    
    case userCanceled
    case success
    
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
    
    public var description: String {
        switch self {
        case .userCanceled:
            return "userCanceled"
        case .success:
            return "success"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public class IAPTransaction : NSObject {
    
    let transaction: Transaction
    
    // MARK: Public Properties
    // MARK: ---
    
    @objc public static let TransactionDidFinishNotification = NSNotification.Name("IAPTransactionDidFinishNotification")
    
    @objc public let environment: IAPAppStoreEnvironment
    @objc public let originalPurchaseDate: Date
    @objc public let originalTransactionID: UInt64
    @objc public let transactionID: UInt64
    @objc public let webOrderLineItemID: String?
    @objc public let appBundleID: String
    @objc public let productID: String
    @objc public let productType: IAPProductType
    @objc public let subscriptionGroupID: String?
    @objc public let purchaseDate: Date
    @objc public let expirationDate: Date?
    @objc public let isUpgraded: Bool
    @objc public let ownershipType: IAPTransactionOwnershipType
    @objc public let purchasedQuantity: Int
    @objc public let reason: IAPTransactionReason
    @objc public let offer: IAPOffer?
    @objc public let revocationDate: Date?
    @objc public let revocationReason: IAPRevocationReason
    @objc public let appAccountToken: UUID?
    
    @objc public var currencyCode: String? {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            return self.transaction.currency?.identifier
        } else {
            return self.transaction.currencyCode
        }
    }
    
    @objc public var price: Decimal {
        guard let price = self.transaction.price else {
            return 0
        }
        return price
    }

    // MARK: Init
    // MARK: ---
    
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
    // MARK: --
    
    public override var description : String {
        
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
    // MARK: --
    
    @objc public func subscriptionStatus() async -> IAPSubscriptionStatus? {
        
        guard let subscriptionStatus = await self.transaction.subscriptionStatus else {
            return nil
        }
        
        return IAPSubscriptionStatus(subscriptionStatus)
    }
            
    @objc public static func latest(forProductID productID: String) async -> IAPTransaction? {
                
        let verificationResult = await Transaction.latest(for: productID)
        
        return IAPTransaction.transaction(fromVerificationResult: verificationResult)
    }
    
    @objc public static func latest(forProductIDs productIDs: [String]) async -> [IAPTransaction] {
                
        return await withTaskGroup(of: IAPTransaction?.self) { group in

            for productID in productIDs {
                group.addTask {
                    return await IAPTransaction.latest(forProductID: productID)
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
    
    @objc public static func all() async -> [IAPTransaction] {
        
        var all: [IAPTransaction] = []
        
        for await verificationResult in Transaction.all {
            if let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) {
                all.append(transaction);
            }
        }
        
        return all
    }
    
    @objc public static func currentEntitlements() async -> [IAPTransaction] {
        
        var currentEntitlements: [IAPTransaction] = []
        
        for await verificationResult in Transaction.currentEntitlements {
            if let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) {
                currentEntitlements.append(transaction);
            }
        }
        
        return currentEntitlements
    }
    
    @objc public static func currentEntitlement(forProductID productID: String) async -> IAPTransaction? {
        
        let verificationResult = await Transaction.currentEntitlement(for: productID)
        
        return IAPTransaction.transaction(fromVerificationResult: verificationResult)
    }
    
    @objc public static func currentEntitlements(forProductIDs productIDs: [String]) async -> [IAPTransaction] {
       
        let  currentEntitlements = await IAPTransaction.currentEntitlements()
        let matchingEntitlements = currentEntitlements.filter { entitlement in
            return productIDs.contains(entitlement.productID)
        }
                
        return matchingEntitlements
    }
    
    @objc public func finish() async {
        
        await self.transaction.finish()
        
        NotificationCenter.default.post(name: IAPTransaction.TransactionDidFinishNotification, object: self)
    }
    
#if os(iOS)
    @objc public func beginRefundRequest(in scene: UIWindowScene) async throws -> IAPRefundRequestStatus {
        
        let status = try await self.transaction.beginRefundRequest(in: scene)
        return IAPRefundRequestStatus(status)
    }
    
    @objc public static func beginRefundRequest(for transactionID: UInt64, in scene: UIWindowScene) async throws -> IAPRefundRequestStatus {
        
        let status = try await Transaction.beginRefundRequest(for: transactionID, in: scene)
        return IAPRefundRequestStatus(status)
    }
#endif
        
    public static func transaction(fromVerificationResult verificationResult:  VerificationResult<Transaction>?) -> IAPTransaction? {
        
        switch verificationResult {
        case .verified(let transaction):
            return IAPTransaction(transaction)
        case .unverified(let unverifiedTransaction, let verificationError):
            debugPrint("unverifiedTransaction: " + unverifiedTransaction.debugDescription)
            debugPrint("verificationError: " + verificationError.localizedDescription)
            return nil
        case nil:
            return nil
        }
    }
}
