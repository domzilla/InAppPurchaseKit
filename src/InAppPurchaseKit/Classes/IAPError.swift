//
//  IAPError.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 15.06.24.
//

import Foundation
import StoreKit

@objc public enum IAPErrorCode: Int {
    case unknown = 0
    case networkError
    case systemError
    case userCancelled
    case notAvailableInStorefront
    case notEntitled
}

@objc public class IAPError : NSObject {

    @objc public static func errorCodeFromStoreKitError(error: Error?) -> IAPErrorCode {
        
        guard let storeKitError = error as? StoreKitError else {
            return .unknown
        }
        
        switch storeKitError {
        case StoreKitError.networkError(_):
            return .networkError
        case StoreKitError.systemError(_):
            return .systemError
        case StoreKitError.userCancelled:
            return .userCancelled
        case StoreKitError.notAvailableInStorefront:
            return .notAvailableInStorefront
        case StoreKitError.notEntitled:
            return .notEntitled
        default:
            return .unknown
        }
    }
}
