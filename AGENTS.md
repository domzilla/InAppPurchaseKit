# InAppPurchaseKit - AGENTS.md

## Project Overview
A Swift wrapper around Apple's StoreKit2 APIs with full Objective-C compatibility. Provides `@objc`-annotated classes that mirror StoreKit2 types, enabling Objective-C codebases to use modern in-app purchase, subscription, and transaction management APIs.

## Tech Stack
- **Language**: Swift (with Objective-C bridging via `@objc`)
- **Type**: Xcode Framework
- **Target Platforms**: iOS 15.6+, macOS 12.4+
- **Dependencies**: StoreKit (Apple framework only — no third-party or local framework dependencies)

## Style & Conventions (MANDATORY)
Style guides are loaded automatically via `~/.claude/rules/` based on file type.
- **Swift** (`*.swift`): `~/Agents/Style/swift-swiftui-style-guide.md`

## Changelog (MANDATORY)
**All important code changes** (fixes, additions, deletions, changes) have to written to CHANGELOG.md.
Changelog format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Before writing to CHANGELOG.md:**
1. Check for new release tags: `git tag --sort=-creatordate | head -1`
2. Release tags are prefixed with `v` (e.g., `v2.0.1`)
3. If a new tag exists that isn't in CHANGELOG.md, create a new version section with that tag's version and date, moving relevant [Unreleased] content under it

## Logging (MANDATORY)

This framework currently has no logging dependencies. If logging is added in the future:

### Swift (DZFoundation)
```swift
import DZFoundation

DZLog("Starting fetch")       // General debug output
DZErrorLog(error)             // Conditional error logging (only prints if error is non-nil)
```

**Do NOT use:**
- `print()` / `NSLog()` for debug output
- `os.Logger` instances

All logging functions are no-ops in release builds.

## API Documentation
Local Apple API documentation is available at:
`~/Agents/API Documentation/Apple/`

```bash
~/Agents/API\ Documentation/Apple/search --help  # Run once per session
~/Agents/API\ Documentation/Apple/search "StoreKit Product" --language swift
~/Agents/API\ Documentation/Apple/search "Transaction" --language swift
```

## Xcode Project Files (CATASTROPHIC — DO NOT TOUCH)
- **NEVER edit Xcode project files** (`.xcodeproj`, `.xcworkspace`, `project.pbxproj`, `.xcsettings`, etc.)
- Editing these files will corrupt the project — this is **catastrophic and unrecoverable**
- Only the user edits project settings, build phases, schemes, and file references manually in Xcode
- If a file needs to be added to the project, **stop and tell the user** — do not attempt it yourself
- Use `xcodebuild` for building/testing only — never for project manipulation
- **Exception**: Only proceed if the user gives explicit permission for a specific edit

## File System Synchronized Groups (Xcode 16+)
This project uses **File System Synchronized Groups** (internally `PBXFileSystemSynchronizedRootGroup`), introduced in Xcode 16. This means:
- The `Classes/` and `Resources/` directories are **directly synchronized** with the file system
- **You CAN freely create, move, rename, and delete files** in these directories
- Xcode automatically picks up all changes — no project file updates needed
- This is different from legacy Xcode groups, which required manual project file edits

**Bottom line:** Modify source files in `Classes/` and `Resources/` freely. Just never touch the `.xcodeproj` files themselves.

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
This project uses **Swift Testing** (`@Test`, `@Suite`, `#expect`). Tests live in `src/InAppPurchaseKitTests/`.

**Run tests after every code change:**
```bash
# iOS
xcodebuild test -project src/InAppPurchaseKit.xcodeproj -scheme InAppPurchaseKitTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug

# macOS (Mac Catalyst)
xcodebuild test -project src/InAppPurchaseKit.xcodeproj -scheme InAppPurchaseKitTests \
  -destination 'platform=macOS,variant=Mac Catalyst' -configuration Debug
```

**Rules:**
- Tests **must pass** before handoff for every supported platform — do not leave broken tests
- When adding or changing public API, **add or update corresponding tests**
- When removing public API, **remove the corresponding tests**
- One test file per public class

**Troubleshooting:**
If tests hang due to parallel execution (e.g., port conflicts), add .serialized to the affected @Suite declarations.
For example: `@Suite("MyTests", .serialized, .tags(.integration))`

**When tests fail:**
- Fix the root cause — do not skip or disable tests
- If a test failure reveals a real bug in the framework, fix the framework code

## Code Formatting — Swift Only (MANDATORY)
**Always run SwiftFormat after modifying Swift files:**
```bash
swiftformat .
```

SwiftFormat configuration is defined in `.swiftformat` at the project root. This enforces:
- 4-space indentation
- Explicit `self.` usage
- K&R brace style (Swift only — Objective-C uses Allman style per the ObjC style guide)
- Trailing commas in collections
- Consistent wrapping rules

**Do not commit unformatted Swift code.**

Objective-C files are not auto-formatted — follow the ObjC style guide manually.

---

## Notes
- All public APIs must have documentation comments
- All Swift classes use `@objc` and `@objcMembers` for Objective-C bridging
- StoreKit2 availability checks are used extensively — respect `@available` annotations
- The framework has no user-facing strings; localization is not applicable
