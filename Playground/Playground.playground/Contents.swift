
import Foundation
import Storez

//: # Storez 💾
//: ### Safer key-value stores
//: __NOTE:__ This is an OSX playground in order to test NSUserDefaults

//: ## Features
//: Type-safe, store-agnostic, nestable Entry definitions

// Entries must belong to a "group", for namespacing
struct Animals: Group {
    static let id = "animals"
}

let kingdom = Entry<Animals, Void?>(id: "mammals", defaultValue: nil)
kingdom.key // "animals:mammals"

// Nesting
struct Cats: Group {
    typealias Parent = Animals
    static let id = "cats"
    
    // Groups also have pre and post commit hooks
    func postCommitHook() {
        // do something when values change
    }
}

let cat = Entry<Cats, Void?>(id: "lion", defaultValue: nil)
cat.key     // "animals:cats:lion"

//: Initialize the store you want

// Currently, only UserDefaultsStore is implemented
let store = UserDefaultsStore(suite: "io.kitz.testing")
let entry = Entry<GlobalGroup, Int?>(id: "entry", defaultValue: nil)

// With three simple functions
store.set(entry, value: 8)
store.get(entry) // 8
store.clear() // Start fresh every time for testing

//: Optionality is honored throughout

let nullable = Entry<GlobalGroup, String?>(id: "nullable", defaultValue: nil)
store.get(nullable)?.isEmpty   // nil
store.set(nullable, value: "")
store.get(nullable)?.isEmpty   // true

let nonnull = Entry<GlobalGroup, String>(id: "nonnull", defaultValue: "!")
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
    typealias UnderlyingType = NSString
    
    static func decode(value: UnderlyingType) -> CustomObject? {
        return self.init(strings: value.componentsSeparatedByString(";"))
    }
    
    var encode: UnderlyingType? {
        return strings.joinWithSeparator(";")
    }
}

// custom objects properly serialized/deserialized
let customObject = CustomObject(
    strings: ["fill", "in", "the"]
)

// let's add a processing block this time
let CustomValue = Entry<GlobalGroup, CustomObject?>(id: "custom", defaultValue: nil) {
    
    var processedValue = $0
    processedValue?.strings.append("blank!")
    return processedValue
}

store.set(CustomValue, value: customObject)
store.get(CustomValue)?.strings.joinWithSeparator(" ") // fill in the blank!

//: Make your own `EntryType`

// For example, make an entry that emits NSNotifications
struct MyEntry<G: Group, V>: EntryType {
    
    typealias GroupType = G
    typealias ValueType = V
    
    var key: String
    var defaultValue: ValueType
    
    func willChange(newValue: ValueType) -> ValueType {
        NSNotificationCenter.defaultCenter().postNotificationName(key, object: nil)
        return newValue
    }
}

