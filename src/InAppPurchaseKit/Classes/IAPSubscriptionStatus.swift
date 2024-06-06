//
//  IAPSubscriptionStatus.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 04.06.24.
//

import Foundation
import StoreKit

@objc public enum IAPSubscriptionRenewalState: Int, CustomStringConvertible {
    case undefined = 0
    
    //Entitled for service
    case subscribed
    case inGracePeriod
    //Not entitled for service
    case expired
    case inBillingRetryPeriod
    case revoked
    
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
    
    public var description: String {
        switch self {
        case .subscribed:
            return "subscribed"
        case .inGracePeriod:
            return "inGracePeriod"
        case .expired:
            return "expired"
        case .inBillingRetryPeriod:
            return "inBillingRetryPeriod"
        case .revoked:
            return "revoked"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public enum IAPSubscriptionExpirationReason: Int, CustomStringConvertible {
    case none = 0 //not expired
    
    case autoRenewDisabled
    case billingError
    case didNotConsentToPriceIncrease
    case productUnavailable
    case unknown
    
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
    
    public var description: String {
        switch self {
        case .autoRenewDisabled:
            return "autoRenewDisabled"
        case .billingError:
            return "billingError"
        case .didNotConsentToPriceIncrease:
            return "didNotConsentToPriceIncrease"
        case .productUnavailable:
            return "productUnavailable"
        case .unknown:
            return "unknown"
        case .none:
            return "none"
        }
    }
}

@objc public class IAPSubscriptionStatus : NSObject {
    
    let status: Product.SubscriptionInfo.Status
    let renewalInfo: Product.SubscriptionInfo.RenewalInfo?
    
    // MARK: Public Properties
    // MARK: ---
    
    @objc public let state: IAPSubscriptionRenewalState
    @objc public let transaction: IAPTransaction?
    
    @objc public var willAutoRenew: Bool {
        guard let renewalInfo = self.renewalInfo else {
            return false
        }
        return renewalInfo.willAutoRenew
    }
     
    @objc public var expirationReason: IAPSubscriptionExpirationReason {
        return IAPSubscriptionExpirationReason(self.renewalInfo?.expirationReason)
    }
        
    @objc public var renewalDate: Date? {
        return self.renewalInfo?.renewalDate
    }
    
    @objc public var gracePeriodExpirationDate: Date? {
        return self.renewalInfo?.gracePeriodExpirationDate
    }
    
    // MARK: Init
    // MARK: ---
    
    init(_ fromStatus: Product.SubscriptionInfo.Status) {
        
        self.status = fromStatus
        
        self.state = IAPSubscriptionRenewalState(self.status.state)
        self.transaction = IAPTransaction.transaction(fromVerificationResult: self.status.transaction)
        
        switch self.status.renewalInfo {
        case .verified(let renewalInfo):
            self.renewalInfo = renewalInfo
        case .unverified(let unverifiedRenewalInfo, let verificationError):
            debugPrint("unverifiedRenewalInfo: " + unverifiedRenewalInfo.debugDescription)
            debugPrint("verificationError: " + verificationError.localizedDescription)
            self.renewalInfo = nil
        }
    }
    
    // MARK: Overridden
    // MARK: --
    
    public override var description : String {
        
        var description = super.description + "\n"
        
        description += "state: \(self.state.description) \n"
        description += "willAutoRenew: \(self.willAutoRenew) \n"
        description += "expirationReason: \(self.expirationReason.description) \n"
        description += "renewalDate: \(String(describing: self.renewalDate)) \n"
        description += "gracePeriodExpirationDate: \(String(describing: self.gracePeriodExpirationDate)) \n"
        
        return description
    }
}
