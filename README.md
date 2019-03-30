
<h1 align="center">
  Storez :floppy_disk:
<h6 align="center">
  Safe, statically-typed, store-agnostic key-value storage
</h6>
</h1>

<p align="center">
  <img alt="Version" src="https://img.shields.io/badge/version-3.0.1-blue.svg" />
  <a alt="Travis CI" href="https://travis-ci.org/SwiftKitz/Storez">
    <img alt="Version" src="https://travis-ci.org/SwiftKitz/Storez.svg?branch=master" />
  </a>
  <img alt="Swift" src="https://img.shields.io/badge/swift-5.0-orange.svg" />
  <img alt="Platforms" src="https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-lightgrey.svg" />
  <a alt="Carthage Compatible" href="https://github.com/SwiftKitz/Notificationz#carthage">
    <img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" />
  </a>
</p>

## Highlights

+ __Fully Customizable:__<br />
Customize the persistence store, the `KeyType` class, post-commit actions .. Make this framework yours!

+ __Batteries Included__:<br />
In case you just want to use stuff, the framework is shipped with pre-configured basic set of classes that you can just use.

+ __Portability, Check!:__<br />
If you're looking to share code between you app and extensions, watchkit, apple watch, you're covered! You can use the `NSUserDefaults` store, just set your shared container identifier as the suite name.

**Example:**

```swift
final class WeatherService {

  private enum Keys: Namespace {
    static let id = "weather-service"
    static let temperature = Key<Keys, Double>(id: "temp", defaultValue: 0.0)
  }

  private let store: UserDefaultsStore
  
  var temperature: Double {
    return store.get(Keys.temperature)
  }

  init(store: UserDefaultsStore) {
    self.store = store
  }

  func weatherUpdate(temperature: Double) {
    store.set(Keys.temperature, temperature)
  }
}
```

## Features

__Available Stores__

| Store | Backend | Subspec |
|-------|---------|---------|
| `UserDefaultsStore` | `NSUserDefaults` | `Storez/UserDefaults` |
| `CacheStore` | `NSCache` | `Storez/Cache` |

For all stores, simply use `pod "Storez"`

__Type-safe, store-agnostic, nestable Key definitions__

```swift
// Entries must belong to a "group", for namespacing
struct Animals: Namespace {
    static let id = "animals"
}

let kingdom = Key<Animals, Void?>(id: "mammals", defaultValue: nil)
kingdom.stringValue // "animals:mammals"

// Nesting
struct Cats: Namespace {
    typealias parent = Animals
    static let id = "cats"

    // Namespaces also have pre and post commit hooks
    func preCommitHook() { /* custom code */ }
    func postCommitHook() { /* custom code */ }
}

let cat = Key<Cats, Void?>(id: "lion", defaultValue: nil)
cat.stringValue // "animals:cats:lion"
```

__Initialize the store you want__

```swift
// Use UserDefaultsStore for this example
let store = UserDefaultsStore(suite: "io.kitz.testing")
let key = Key<GlobalNamespace, Int?>(id: "key", defaultValue: nil)

// With three simple functions
store.set(key, value: 8)
store.get(key) // 8
store.clear() // Start fresh every time for testing
```

__Optionality is honored throughout__

```swift
let nullable = Key<GlobalNamespace, String?>(id: "nullable", defaultValue: nil)
store.get(nullable)?.isEmpty   // nil
store.set(nullable, value: "")
store.get(nullable)?.isEmpty   // true

let nonnull = Key<GlobalNamespace, String>(id: "nonnull", defaultValue: "!")
store.get(nonnull).isEmpty  // false
store.set(nonnull, value: "")
store.get(nonnull).isEmpty  // true
```

__Custom objects easily supported__

**NEW** Simply conform to `Codable`!

_(You can still use `UserDefaultsConvirtable` if needed)_

```swift
struct CustomObject: Codable {
    var strings: [String]
}

// custom objects properly serialized/deserialized
let customObject = CustomObject(
    strings: ["fill", "in", "the"]
)

// let's add a processing block this time
let CustomValue = Key<GlobalNamespace, CustomObject?>(id: "custom", defaultValue: nil) {

    var processedValue = $0
    processedValue?.strings.append("blank!")
    return processedValue
}

store.set(CustomValue, value: customObject)
store.get(CustomValue)?.strings.joinWithSeparator(" ") // fill in the blank!
```

__Make your own `KeyType`__

```swift
// For example, make an key that emits NSNotifications
struct MyKey<G: Namespace, V>: KeyType {

    typealias NamespaceType = G
    typealias ValueType = V

    var stringValue: String
    var defaultValue: ValueType

    func didChange(oldValue: ValueType, newValue: ValueType) {
        NSNotificationCenter.defaultCenter().postNotificationName(stringValue, object: nil)
    }
}
```

## Getting Started

### Carthage

[Carthage][carthage-link] is fully supported. Simply add the following line to your [Cartfile][cartfile-docs]:

```ruby
github "SwiftKitz/Storez"
```

### CocoaPods

[CocoaPods][cocoapods-link] is fully supported. You can choose which store you want to use (see above). Simply add the following line to your [Podfile][podfile-docs]:

```ruby
pod 'Storez/UserDefaults'
```

### Submodule

For manual installation, you can grab the source directly or through git submodules, then simply:

+ Drop the `Storez.xcodeproj` file as a subproject (make sure `Copy resources` is __not__ enabled)
+ Navigate to your root project settings. Under "Embedded Binaries", click the "+" button and select the `Storez.framework`

## Motivation

I've seen a lot of great attempts at statically-types data stores, but they all build a tightly coupled design that limits the end-developer's freedom. With this framework, you can start prototyping right away with the shipped features, then replace the persistence store and `KeyType` functionality with your heart's content __and__ keep your code the way it is!

## Author

Mazyod ([@Mazyod](http://twitter.com/mazyod))

## License

Storez is released under the MIT license. See LICENSE for details.


[carthage-link]: https://github.com/Carthage/Carthage
[cartfile-docs]: https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile
[cocoapods-link]: https://cocoapods.org/
[podfile-docs]: https://guides.cocoapods.org/syntax/podfile.html
[v1.0.0-link]: https://github.com/SwiftKitz/Storez/releases/tag/v1.0.0
