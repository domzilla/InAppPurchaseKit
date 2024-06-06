//
//  IAPSubscriptionPeriod.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

@objc public enum IAPSubscriptionPeriodUnit: Int {
    case undefined = 0
    
    case day
    case month
    case week
    case year
    
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
        
    public var description: String {
        switch self {
        case .day:
            return "day"
        case .month:
            return "month"
        case .week:
            return "week"
        case .year:
            return "year"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public class IAPSubscriptionPeriod : NSObject {
    
    let period: Product.SubscriptionPeriod
    
    // MARK: Public Properties
    // MARK: --
    
    @objc public let value: Int
    @objc public let unit: IAPSubscriptionPeriodUnit
    
    // MARK: Init
    // MARK: --
    
    init(_ fromPeriod: Product.SubscriptionPeriod) {
        self.period = fromPeriod
        
        self.value = self.period.value
        self.unit = IAPSubscriptionPeriodUnit(self.period.unit)
    }
}
