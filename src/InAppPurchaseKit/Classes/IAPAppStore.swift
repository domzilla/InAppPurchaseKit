//
//  IAPAppStore.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 05.06.24.
//

import Foundation
import StoreKit

@objc public enum IAPAppStoreEnvironment: Int, LosslessStringConvertible {
    case undefined = 0
    
    case production
    case sandbox
    case xcode
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
    public init(_ environment: AppStore.Environment) {
        switch environment {
        case .production:
            self = .production
        case .sandbox:
            self = .sandbox
        case .xcode:
            self = .xcode
        default:
            self = .undefined
        }
    }
    
    public init(_ description: String) {
        switch description.lowercased() {
        case "production":
            self = .production
        case "sandbox":
            self = .sandbox
        case "xcode":
            self = .xcode
        default:
            self = .undefined
        }
    }
        
    public var description: String {
        switch self {
        case .production:
            return "production"
        case .sandbox:
            return "sandbox"
        case .xcode:
            return "xcode"
        case .undefined:
            return "undefined"
        }
    }
}

@objc public class IAPAppStore : NSObject {
    
    // MARK: Public Properties
    // MARK: ---
    
    @objc public static var canMakePayments: Bool {
        return AppStore.canMakePayments
    }
    
    @objc public static var deviceVerificationID: UUID? {
        return AppStore.deviceVerificationID
    }
    
    // MARK: Public
    // MARK: ---
    
#if os(iOS)
    @objc public static func showManageSubscriptions(in scene: UIWindowScene) async throws {
        try await AppStore.showManageSubscriptions(in: scene)
    }
    
    @available(iOS 17.0, *)
    @objc public static func showManageSubscriptions(in scene: UIWindowScene, subscriptionGroupID: String?) async throws {
        if let subscriptionGroupID = subscriptionGroupID {
            try await AppStore.showManageSubscriptions(in: scene, subscriptionGroupID: subscriptionGroupID)
        } else {
            try await AppStore.showManageSubscriptions(in: scene)
        }
    }
    
    @MainActor @available(iOS 16.0, *)
    @objc public static func requestReview(in scene: UIWindowScene) {
        AppStore.requestReview(in: scene)
    }
    
    @MainActor @available(iOS 16.0, *)
    @objc public static func presentOfferCodeRedeemSheet(in scene: UIWindowScene) async throws {
        try await AppStore.presentOfferCodeRedeemSheet(in: scene)
    }
#endif
    
    @objc public static func sync() async throws {
        try await AppStore.sync()
    }
}
