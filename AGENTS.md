# InAppPurchaseKit - AGENTS.md

## Project Overview
A Swift wrapper around Apple's StoreKit2 APIs with full Objective-C compatibility. Provides `@objc`-annotated classes that mirror StoreKit2 types, enabling Objective-C codebases to use modern in-app purchase, subscription, and transaction management APIs.

## Tech Stack
- **Language**: Swift (with Objective-C bridging via `@objc`)
- **Type**: Xcode Framework
- **Target Platforms**: iOS, macOS
- **Dependencies**: StoreKit (Apple framework only — no third-party or local framework dependencies)

## Guides (MANDATORY)
- Objective-C style: `~/Agents/Style/objc-style-guide.md`
- Swift style: `~/Agents/Style/swift-swiftui-style-guide.md`
- Accessibility: `~/Agents/Guides/accessibility-guide.md`
- Xcode projects: `~/Agents/Guides/xcode-project-guide.md`

## Build Commands
```bash
# Build (iOS)
xcodebuild -project src/InAppPurchaseKit.xcodeproj -scheme InAppPurchaseKit \
  -destination 'generic/platform=iOS' \
  -configuration Debug build

# Build (macOS)
xcodebuild -project src/InAppPurchaseKit.xcodeproj -scheme InAppPurchaseKit \
  -destination 'generic/platform=macOS' \
  -configuration Debug build

# Clean
xcodebuild -project src/InAppPurchaseKit.xcodeproj -scheme InAppPurchaseKit clean
```

## Testing (MANDATORY)
**Run tests after every code change:**
```bash
# iOS
xcodebuild test -project src/InAppPurchaseKit.xcodeproj -scheme InAppPurchaseKitTests \
  -destination 'platform=iOS Simulator,name=<available iPhone>' -configuration Debug

# macOS (Mac Catalyst)
xcodebuild test -project src/InAppPurchaseKit.xcodeproj -scheme InAppPurchaseKitTests \
  -destination 'platform=macOS,variant=Mac Catalyst' -configuration Debug
```

## Notes
- All Swift classes use `@objc` and `@objcMembers` for Objective-C bridging
- StoreKit2 availability checks are used extensively — respect `@available` annotations
- The framework has no user-facing strings; localization is not applicable
