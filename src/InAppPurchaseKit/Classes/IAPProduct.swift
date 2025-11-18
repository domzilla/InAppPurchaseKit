//
//  IAPProduct.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

@objc public enum IAPProductType: Int, CustomStringConvertible {
    case undefined = 0
    
    case consumable
    case nonConsumable
    case nonRenewable
    case autoRenewable
    
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
        
    public var description: String {
        switch self {
        case .consumable:
            return "consumable"
        case .nonConsumable:
            return "nonConsumable"
        case .nonRenewable:
            return "nonRenewable"
        case .autoRenewable:
            return "autoRenewable"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public enum IAPPaymentMode: Int, LosslessStringConvertible {
    case undefined = 0
    
    case freeTrial
    case payAsYouGo
    case payUpFront
    
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
        
    public var description: String {
        switch self {
        case .freeTrial:
            return "freeTrial"
        case .payAsYouGo:
            return "payAsYouGo"
        case .payUpFront:
            return "payUpFront"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public enum IAPPurchaseResult: Int {
    case undefined = 0
    
    case success
    case userCancelled
    case pending
    
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
        
    public var description: String {
        switch self {
        case .success:
            return "success"
        case .userCancelled:
            return "userCancelled"
        case .pending:
            return "pending"
        case .undefined:
            return "undefined"
        }
    }
}
 
@objc public class IAPProduct : NSObject {
    
    let product: Product
    
    // MARK: Public Properies
    // MARK: --
    
    @objc public let productID: String
    @objc public let type: IAPProductType
    
    @objc public let displayName: String
    @objc public let productDescription: String
    @objc public let displayPrice: String
    @objc public let price: Decimal
    
    @objc public let subscription: IAPSubscriptionInfo?
    
    @objc public let isFamilyShareable: Bool
    
    // MARK: Init
    // MARK: ---
    
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
    // MARK: --
    
    public override var description : String {
        
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
    // MARK: ---
    
    @objc public static func products(for identifiers: [String]) async throws -> [IAPProduct]? {
        do {
            let loadedProducts = try await Product.products(for: identifiers)
            
            var products : [IAPProduct] = []
            for loadedProduct in loadedProducts {
                products.append(IAPProduct(loadedProduct))
            }
            
            return products
            
        } catch {
            throw error
        }
    }
    
    @objc public func purchase() async throws -> (IAPTransaction?, IAPPurchaseResult) {
        
        let purchaseResult = try await self.product.purchase()
                
        return await self.processPurchaseResult(purchaseResult)
    }
    
#if os(iOS)
    @available(iOS 17.0, tvOS 17.0, visionOS 1.0, *)
    @objc public func purchase(confirmIn scene: UIScene) async throws -> (IAPTransaction?, IAPPurchaseResult) {
        
        let purchaseResult = try await self.product.purchase(confirmIn: scene)
                
        return await self.processPurchaseResult(purchaseResult)
    }
#endif
    
    @objc public func currentEntitlement() async -> IAPTransaction? {
        
        let verificationResult: VerificationResult? = await self.product.currentEntitlement
        guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
            return nil
        }
        
        return transaction
    }
    
    @objc public func latestTransaction() async -> IAPTransaction? {
        
        let verificationResult: VerificationResult? = await self.product.latestTransaction
        guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
            return nil
        }
        
        return transaction
    }
    
    // MARK: Private
    // MARK: ---
    private func processPurchaseResult(_ purchaseResult:Product.PurchaseResult) async -> (IAPTransaction?, IAPPurchaseResult) {
        
        switch purchaseResult {
        case .success(let verificationResult):
            guard let transaction = IAPTransaction.transaction(fromVerificationResult: verificationResult) else {
                return (nil, .undefined)
            }
            await transaction.finish() //Always finish a transaction.
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
