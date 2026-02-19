# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Storez is a Swift library providing type-safe, namespace-scoped key-value storage. It ships two store backends: `UserDefaultsStore` (persistent, backed by `UserDefaults`) and `CacheStore` (in-memory, backed by `NSCache`). There are no external dependencies.

## Build & Test Commands

```bash
swift build -v        # Build the library
swift test -v         # Run all tests
swift test -v --filter StorezTests.CacheStoreTests          # Run a single test class
swift test -v --filter StorezTests.CacheStoreTests/testFoo  # Run a single test method
```

```bash
swift build -Xswiftc -strict-concurrency=complete  # Verify concurrency safety
```

Platform minimums: iOS 15, macOS 12, tvOS 15, watchOS 8. Swift tools version 6.0.

## Architecture

### Core Layer (`Sources/Storez/Entity/`)

The design is built around three protocols:

- **`Namespace`** — Groups keys under a colon-separated path (e.g. `"App:Weather"`). Supports nesting via an associated `parent` type. Provides optional `preCommitHook()` / `postCommitHook()` statics.
- **`KeyType`** — Defines a key with `NamespaceType`, `ValueType`, `stringValue`, `defaultValue`, and three lifecycle hooks: `willChange`, `processChange`, `didChange`.
- **`Store`** — Minimal protocol requiring only `clear()`.

`Key<G: Namespace, V>` is the concrete generic key struct. Its `stringValue` combines the namespace path and key id. It adds an optional `changeBlock` that runs inside `processChange`.

`Nullable` protocol extends `Optional` to allow generic handling of optional value types across store implementations.

### Store Implementations (`Sources/Storez/Stores/`)

Both stores follow the same internal pattern:
1. `_read` — decodes raw storage into typed values via a **transaction box**
2. `_write` — calls pre/post commit hooks around the actual write
3. `_set` — orchestrates: read old value → `processChange` → `willChange` → write → `didChange`
4. Public `get`/`set` overloads constrained by type category

**Transaction boxes** (e.g. `UserDefaultsSupportedTypeBox`, `CacheSupportedBox`) bridge between the store's native storage format and Swift value types. Each box conforms to `UserDefaultsTransaction` or `CacheTransaction`.

**Type conversion protocols:**
- `UserDefaultsConvertible` — custom types bridge into UserDefaults (with legacy NSCoding migration support)
- `CacheConvertible` — custom types bridge into NSCache (Swift primitives conform via `CacheConvertible+Swift.swift`)

### Tests (`Tests/StorezTests/`)

Tests use XCTest with no third-party dependencies. `Common/` contains shared helpers: `TestNamespace` and `CustomObject` (a Codable test type). Both store test classes call `store.clear()` in `setUp()` for isolation.

## Concurrency

Swift 6 language mode is enabled on both targets via `.swiftLanguageMode(.v6)` in Package.swift. Both stores conform to `@unchecked Sendable`. `Key` has conditional `Sendable where V: Sendable` conformance (the `ChangeBlock` typealias is marked `@Sendable`, enabling clean conformance without `@unchecked`). `GlobalNamespace` conforms to `Sendable`. The library compiles cleanly with `-strict-concurrency=complete`.

## Privacy

Includes `PrivacyInfo.xcprivacy` declaring `UserDefaults` usage (reason `CA92.1`), required for App Store submission since May 2024.
