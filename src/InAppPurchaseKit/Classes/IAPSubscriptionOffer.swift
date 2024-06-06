//
//  IAPSubscriptionOffer.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

extension IAPOfferType {
    
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

@objc public class IAPSubscriptionOffer : IAPOffer {
    
    let subscriptionOffer: Product.SubscriptionOffer
    
    // MARK: Public Properties
    // MARK: --
    
    @objc public let displayPrice: String
    @objc public let price: Decimal
    @objc public let period: IAPSubscriptionPeriod
    @objc public  let periodCount: Int
    
    // MARK: Init
    // MARK: --
    
    init(_ fromSubscriptionOffer: Product.SubscriptionOffer) {
        
        self.subscriptionOffer = fromSubscriptionOffer
        
        self.displayPrice = self.subscriptionOffer.displayPrice
        self.price = self.subscriptionOffer.price
        self.period = IAPSubscriptionPeriod(self.subscriptionOffer.period)
        self.periodCount = self.subscriptionOffer.periodCount
        
        super.init(offerID: fromSubscriptionOffer.id, type: IAPOfferType(fromSubscriptionOffer.type), paymentMode: IAPPaymentMode(fromSubscriptionOffer.paymentMode))
    }
}
