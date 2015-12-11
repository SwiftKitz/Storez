
import Foundation
import Storez

//: # Storez 💾
//: ### Safe, statically-typed, store-agnostic key-value storage!
//: __NOTE:__ This is an OSX playground in order to test NSUserDefaults

//: ## Features
//: Type-safe, store-agnostic, nestable Key definitions

// Entries must belong to a "group", for namespacing
struct Animals: Group {
    static let id = "animals"
}

let kingdom = Key<Animals, Void?>(id: "mammals", defaultValue: nil)
kingdom.key // "animals:mammals"

// Nesting
struct Cats: Group {
    typealias parent = Animals
    static let id = "cats"
    
    // Groups also have pre and post commit hooks
    func postCommitHook() {
        // do something when values change
    }
}

let cat = Key<Cats, Void?>(id: "lion", defaultValue: nil)
cat.key     // "animals:cats:lion"

//: Initialize the store you want

// Currently, only UserDefaultsStore is implemented
let store = UserDefaultsStore(suite: "io.kitz.testing")
let entry = Key<GlobalGroup, Int?>(id: "entry", defaultValue: nil)

// With three simple functions
store.set(entry, value: 8)
store.get(entry) // 8
store.clear() // Start fresh every time for testing

//: Optionality is honored throughout

let nullable = Key<GlobalGroup, String?>(id: "nullable", defaultValue: nil)
store.get(nullable)?.isEmpty   // nil
store.set(nullable, value: "")
store.get(nullable)?.isEmpty   // true

let nonnull = Key<GlobalGroup, String>(id: "nonnull", defaultValue: "!")
store.get(nonnull).isEmpty  // false
store.set(nonnull, value: "")
store.get(nonnull).isEmpty  // true

//: Custom objects easily supported!

struct CustomObject {
    var strings: [String]
}

// You can guarentee they work for a specific store implementation by
// conforming to the store convertible protocol. In this case,
// NSUserDefaults requires the custom object can be converted to and 
// from a supported Underlying type. (see UserDefaultsValueTypes.swift)
extension CustomObject: UserDefaultsConvertible {
    
    // We want to serialize this struct as NSString
    static func decode(userDefaultsValue value: NSString) -> CustomObject? {
        return self.init(strings: value.componentsSeparatedByString(";"))
    }
    
    var encodeForUserDefaults: NSString? {
        return strings.joinWithSeparator(";")
    }
}

// custom objects properly serialized/deserialized
let customObject = CustomObject(
    strings: ["fill", "in", "the"]
)

// let's add a processing block this time
let CustomValue = Key<GlobalGroup, CustomObject?>(id: "custom", defaultValue: nil) {
    
    var processedValue = $0
    processedValue?.strings.append("blank!")
    return processedValue
}

store.set(CustomValue, value: customObject)
store.get(CustomValue)?.strings.joinWithSeparator(" ") // fill in the blank!

//: Make your own `KeyType`

// For example, make an entry that emits NSNotifications
struct MyKey<G: Group, V>: KeyType {
    
    typealias GroupType = G
    typealias ValueType = V
    
    var key: String
    var defaultValue: ValueType
    
    func didChange(oldValue: ValueType, newValue: ValueType) {
        NSNotificationCenter.defaultCenter().postNotificationName(key, object: nil)
    }
}

