# InAppPurchaseKit - AGENTS.md

## Project Overview
A Swift wrapper around Apple's StoreKit2 APIs with full Objective-C compatibility. Provides `@objc`-annotated classes that mirror StoreKit2 types, enabling Objective-C codebases to use modern in-app purchase, subscription, and transaction management APIs.

## Tech Stack
- **Language**: Swift (with Objective-C bridging via `@objc`)
- **Type**: Xcode Framework
- **Target Platforms**: iOS, macOS
- **Dependencies**: StoreKit (Apple framework only — no third-party or local framework dependencies)

## Guides (MANDATORY)
Read `~/Agents/Guides/xcode-project-guide.md` in full before planning or editing anything.

Read these in full before touching the matching code:
- Swift style (`.swift`): `~/Agents/Style/swift-swiftui-style-guide.md`
- Objective-C style (`.h`, `.m`): `~/Agents/Style/objc-style-guide.md`
- Accessibility (UI code, XIBs, storyboards): `~/Agents/Guides/accessibility-guide.md`

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

The test target is iOS SDK only, so native macOS is not covered by tests.

## Notes
- Objective-C bridging uses `@objc` on each exposed class and member (no `@objcMembers`)
- StoreKit2 availability checks are used extensively — respect `@available` annotations
- The framework has no user-facing strings; localization is not applicable
