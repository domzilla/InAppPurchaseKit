//
//  IAPError.swift
//  InAppPurchaseKit
//
//  Created by Dominic Rodemer on 15.06.24.
//

import Foundation
import StoreKit

/// Error codes representing categorized StoreKit2 errors in an Objective-C compatible format.
///
/// Each case maps to a corresponding `StoreKit.StoreKitError` case, providing a bridgeable
/// integer-based enum that Objective-C code can consume directly.
///
/// - Note: Wraps `StoreKit.StoreKitError` for Objective-C interoperability.
@objc
public enum IAPErrorCode: Int {
    /// An unknown or unrecognized error that does not map to any specific StoreKit error case.
    ///
    /// This is the default value returned when the error is `nil`, not a `StoreKitError`,
    /// or represents a future StoreKit error case not yet handled by this framework.
    case unknown = 0

    /// A network connectivity error occurred during a StoreKit operation.
    ///
    /// Corresponds to `StoreKitError.networkError`.
    case networkError

    /// A system-level error occurred within StoreKit.
    ///
    /// Corresponds to `StoreKitError.systemError`.
    case systemError

    /// The user cancelled the StoreKit operation.
    ///
    /// Corresponds to `StoreKitError.userCancelled`.
    case userCancelled

    /// The product or subscription is not available in the user's current App Store storefront.
    ///
    /// Corresponds to `StoreKitError.notAvailableInStorefront`.
    case notAvailableInStorefront

    /// The user is not entitled to the requested content or action.
    ///
    /// Corresponds to `StoreKitError.notEntitled`.
    case notEntitled
}

/// Utility class for converting StoreKit2 errors into Objective-C compatible error codes.
///
/// `IAPError` provides a static method to translate a `StoreKit.StoreKitError` into an
/// ``IAPErrorCode`` value, enabling Objective-C code to handle StoreKit2 errors through
/// simple integer-based error codes.
///
/// - Note: This class inherits from `NSObject` for Objective-C bridging compatibility.
@objc
public class IAPError: NSObject {
    /// Converts a StoreKit2 error into an Objective-C compatible ``IAPErrorCode``.
    ///
    /// Attempts to cast the provided error to a `StoreKit.StoreKitError` and returns
    /// the corresponding ``IAPErrorCode``. If the error is `nil` or not a `StoreKitError`,
    /// returns ``IAPErrorCode/unknown``.
    ///
    /// - Parameter error: The error to convert, typically caught from a StoreKit2 API call.
    ///   Pass `nil` to receive ``IAPErrorCode/unknown``.
    /// - Returns: The ``IAPErrorCode`` corresponding to the StoreKit2 error, or
    ///   ``IAPErrorCode/unknown`` if the error cannot be mapped.
    @objc
    public static func errorCodeFromStoreKitError(error: Error?) -> IAPErrorCode {
        guard let storeKitError = error as? StoreKitError else {
            return .unknown
        }

        switch storeKitError {
        case StoreKitError.networkError:
            return .networkError
        case StoreKitError.systemError:
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
