
import Foundation
import Storez

//: # Storez 💾
//: ### Safe, statically-typed, store-agnostic key-value storage!
//: __NOTE:__ This is an OSX playground in order to test NSUserDefaults

//: ## Features
//: Type-safe, store-agnostic, nestable Key definitions

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

//: Initialize the store you want

// Use UserDefaultsStore for this example
let store = UserDefaultsStore(suite: "io.kitz.testing")
let key = Key<GlobalNamespace, Int?>(id: "key", defaultValue: nil)

// With three simple functions
store.set(key, value: 8)
store.get(key) // 8
store.clear() // Start fresh every time for testing

//: Optionality is honored throughout

let nullable = Key<GlobalNamespace, String?>(id: "nullable", defaultValue: nil)
store.get(nullable)?.isEmpty   // nil
store.set(nullable, value: "")
store.get(nullable)?.isEmpty   // true

let nonnull = Key<GlobalNamespace, String>(id: "nonnull", defaultValue: "!")
store.get(nonnull).isEmpty  // false
store.set(nonnull, value: "")
store.get(nonnull).isEmpty  // true

//: Custom objects easily supported!

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
store.get(CustomValue)?.strings.joined(separator: " ") // fill in the blank!

//: Make your own `KeyType`

// For example, make an key that emits NSNotifications
struct MyKey<G: Namespace, V>: KeyType {
    
    typealias NamespaceType = G
    typealias ValueType = V
    
    var stringValue: String
    var defaultValue: ValueType
    
    func didChange(oldValue: ValueType, newValue: ValueType) {
        NotificationCenter.default.post(name: .init(stringValue), object: nil)
    }
}

