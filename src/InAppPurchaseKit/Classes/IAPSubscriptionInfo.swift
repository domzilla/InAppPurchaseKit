//
//  IAPSubscriptionInfo.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

@objc public class IAPSubscriptionInfo : NSObject {
        
    let subscriptionInfo: Product.SubscriptionInfo
    
    // MARK: Public Properties
    // MARK: --
    
    @objc public let subscriptionGroupID: String
    
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, visionOS 1.0, *)
    @objc public var groupDisplayName: String {
        return self.subscriptionInfo.groupDisplayName
    }
    
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, visionOS 1.0, *)
    @objc public var groupLevel: Int {
        return self.subscriptionInfo.groupLevel
    }
    
    @objc public let subscriptionPeriod: IAPSubscriptionPeriod
    @objc public let introductoryOffer: IAPSubscriptionOffer?
    @objc public let promotionalOffers: [IAPSubscriptionOffer]
    
    // MARK: Init
    // MARK: --
    
    init(_ fromSubscriptionInfo: Product.SubscriptionInfo) {
        self.subscriptionInfo = fromSubscriptionInfo
        
        self.subscriptionGroupID = self.subscriptionInfo.subscriptionGroupID
        self.subscriptionPeriod = IAPSubscriptionPeriod(self.subscriptionInfo.subscriptionPeriod)
        
        if let introductoryOffer = self.subscriptionInfo.introductoryOffer {
            self.introductoryOffer = IAPSubscriptionOffer(introductoryOffer)
        } else {
            self.introductoryOffer = nil
        }
        
        var promotionalOffers: [IAPSubscriptionOffer] = []
        for promotionalOffer in self.subscriptionInfo.promotionalOffers {
            promotionalOffers.append(IAPSubscriptionOffer(promotionalOffer))
        }
        self.promotionalOffers = promotionalOffers
    }
    
    // MARK: Public
    // MARK: --
    
    @objc public func status() async throws -> [IAPSubscriptionStatus] {
        
        let statuses = try await self.subscriptionInfo.status
        var subscriptionStatuses: [IAPSubscriptionStatus] = []
        for status in statuses {
            subscriptionStatuses.append(IAPSubscriptionStatus(status))
        }
        
        return subscriptionStatuses
    }
    
    @objc public static func status(forGroupID groupID: String) async throws -> [IAPSubscriptionStatus] {
        
        let statuses = try await Product.SubscriptionInfo.status(for: groupID)
        var subscriptionStatuses: [IAPSubscriptionStatus] = []
        for status in statuses {
            subscriptionStatuses.append(IAPSubscriptionStatus(status))
        }
        
        return subscriptionStatuses
    }
    
    @objc public static func isEligibleForIntroOffer(for groupID: String) async -> Bool {
        return await Product.SubscriptionInfo.isEligibleForIntroOffer(for: groupID)
    }
    
    @objc public func isEligibleForIntroOffer() async -> Bool {
        return await self.subscriptionInfo.isEligibleForIntroOffer
    }
}
