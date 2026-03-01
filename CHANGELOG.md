# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Comprehensive `///` documentation comments for all public API types, properties, methods, and enum cases across all 10 source files
- Unit tests for `IAPSubscriptionPeriodUnit`: raw value coverage, `init` mapping from `Product.SubscriptionPeriod.Unit`, and `description` strings

## [November 2025]

### Changed

- Set deployment targets back to iOS 15 / macOS 12
- Raised deployment target (temporarily)

## [June 2025]

### Changed

- Updated project configuration

## [June 2024]

### Added

- PrivacyInfo.xcprivacy manifest for App Store compliance
- Method to access StoreKitError for better error handling
- README with documentation and syntax highlighting
- MIT License
- Example project demonstrating usage
- Mac Catalyst target support
- Initial implementation of InAppPurchaseKit

### Changed

- Made `subscriptionGroupID` optional for flexibility
