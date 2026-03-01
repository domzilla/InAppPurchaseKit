//
//  Tag+Extensions.swift
//  InAppPurchaseKitTests
//
//  Created by Dominic Rodemer on 01.03.26.
//  Copyright © 2026 Dominic Rodemer. All rights reserved.
//

import Testing

extension Tag {
    /// Tests for enum-to-enum mapping initializers (StoreKit → IAP wrapper).
    @Tag static var enumMapping: Self

    /// Tests for string-based initializers that parse human-readable values.
    @Tag static var stringParsing: Self

    /// Tests for error conversion and error code mapping.
    @Tag static var errorHandling: Self

    /// Tests for the transaction observer lifecycle (start, stop, isObserving).
    @Tag static var observer: Self

    /// Tests for property behavior, default values, and computed properties.
    @Tag static var properties: Self
}
