//
//  IAPOffer.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 04.06.24.
//

import Foundation
import StoreKit

@objc public enum IAPOfferType: Int, CustomStringConvertible {
    case undefined = 0
    
    case introductory
    case promotional
    case code
    
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
    
    public var description: String {
        switch self {
        case .introductory:
            return "introductory"
        case .promotional:
            return "promotional"
        case .code:
            return "code"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public class IAPOffer : NSObject {
        
    // MARK: Public Properties
    // MARK: ---
    
    @objc public let offerID: String?
    @objc public let type: IAPOfferType
    @objc public let paymentMode: IAPPaymentMode
    
    // MARK: Init
    // MARK: ---

    @objc public init(offerID: String?, type: IAPOfferType, paymentMode: IAPPaymentMode) {
        self.offerID = offerID
        self.type = type
        self.paymentMode = paymentMode
    }
    
    public static func fromTransaction(_ transaction:Transaction) -> IAPOffer? {
        
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
    // MARK: --
    
    public override var description : String {
        
        var description = super.description + "\n"
        
        description += "offerID: \(self.offerID ?? "nil") \n"
        description += "type: \(self.type.description) \n"
        description += "paymentMode: \(self.paymentMode.description) \n"
        
        return description
    }
}
