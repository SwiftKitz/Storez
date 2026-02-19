//
//  StorezTests.swift
//  StorezTests
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import XCTest
import Storez


class UserDefaultsStoreTests: XCTestCase {
    
    let store = UserDefaultsStore(suite: "io.kitz.storez.test-\(Int.random(in: 0..<999_999_999))")
    
    
    override func setUp() {
        super.setUp()
        
        store.clear()
    }
    
    func testUserDefaultValueTypes() {

        let arrayKey = Key<GlobalNamespace, NSArray>(id: "array", defaultValue: [1])
        let array: NSArray = [1, 2, 3]
        
        XCTAssertEqual(store.get(arrayKey), [1])
        store.set(arrayKey, value: array)
        XCTAssertEqual(store.get(arrayKey), array)
        
        let dateKey = Key<GlobalNamespace, NSDate?>(id: "date", defaultValue: nil)
        let date = NSDate(timeIntervalSinceReferenceDate: 500)
        
        XCTAssertEqual(store.get(dateKey), nil)
        store.set(dateKey, value: date)
        XCTAssertEqual(store.get(dateKey), date)
        // can be set back to nil
        store.set(dateKey, value: nil)
        XCTAssertEqual(store.get(dateKey), nil)
    }

    func testCodableTypes() {

        struct Test: Codable, Equatable {
            let x: Int
        }

        let testKey = Key<GlobalNamespace, Test>(id: "codable", defaultValue: Test(x: 0))

        XCTAssertEqual(store.get(testKey), Test(x: 0))
        store.set(testKey, value: Test(x: 9))
        XCTAssertEqual(store.get(testKey), Test(x: 9))

        let date = Date(timeIntervalSinceNow: 20)
        let dateKey = Key<GlobalNamespace, Date>(id: "codable", defaultValue: date)

        XCTAssertEqual(store.get(dateKey), date)
        store.set(dateKey, value: date.addingTimeInterval(2))
        XCTAssertEqual(store.get(dateKey), date.addingTimeInterval(2))
    }
    
    func testNSCodingConformingTypes() {
        
        let uuidKey = Key<GlobalNamespace, NSUUID?>(id: "uuid", defaultValue: nil)
        let uuid = NSUUID()
        
        XCTAssertEqual(store.get(uuidKey), nil)
        store.set(uuidKey, value: uuid)
        XCTAssertEqual(store.get(uuidKey), uuid)
    }
    
    func testPrimitiveTypes() {
        
        let value = 20.4
        let primitive = Key<GlobalNamespace, Double?>(id: "primitive", defaultValue: nil)
        
        XCTAssertEqual(store.get(primitive), nil)
        store.set(primitive, value: value)
        XCTAssertEqual(store.get(primitive), value)
    }
    
    func testStringType() {
        
        let text = Key<GlobalNamespace, String>(id: "text", defaultValue: "default")
        let value = "testing-string-🇦🇪"

        XCTAssertEqual(store.get(text), "default")
        store.set(text, value: value)
        XCTAssertEqual(store.get(text), value)
    }

    func testOptionalStringType() {

        let text = Key<GlobalNamespace, String?>(id: "text", defaultValue: nil)
        let value = "testing-string-🇦🇪"

        XCTAssertEqual(store.get(text), nil)
        store.set(text, value: value)
        XCTAssertEqual(store.get(text), value)
        // can be set back to nil
        store.set(text, value: nil)
        XCTAssertEqual(store.get(text), nil)
    }
    
    func testCustomObjectType() {
        
        let value = CustomObject(
            title: "Sherlock Holmes",
            year: 1886
        )
        
        let customKey = Key<GlobalNamespace, CustomObject?>(id: "custom-object", defaultValue: nil)
        
        store.set(customKey, value: value)
        XCTAssertEqual(store.get(customKey), value)
    }
    
    func testDefaultValueIsResolved() {
        
        let defaultValue = "default-value"
        let defaultProvider = Key<GlobalNamespace, String>(id: "default-provider", defaultValue: defaultValue)
        
        let value = store.get(defaultProvider)
        XCTAssertEqual(value, defaultValue)
    }
    
    func testChangeBlockIsTriggered() {
        
        let changingKey = Key<GlobalNamespace, String?>(id: "changing-object", defaultValue: nil) {
            return [$0, "Heisenburg"].compactMap { $0 }.joined(separator: " ")
        }

        store.set(changingKey, value: "say my name!")
        XCTAssertEqual(store.get(changingKey), "say my name! Heisenburg")
    }
    
    func testPreCommitHook() {
        
        TestNamespace.preCommitCalls = 0
        
        store.set(TestNamespace.anyKey, value: "new value")
        XCTAssertEqual(TestNamespace.preCommitCalls, 1)
    }
    
    func testPostCommitHook() {
        
        TestNamespace.postCommitCalls = 0
        
        store.set(TestNamespace.anyKey, value: "test")
        XCTAssertEqual(TestNamespace.postCommitCalls, 1)
    }

    func testLegacyCodableConverters() {
        // legacy keys
        let refDate = NSDate(timeIntervalSinceReferenceDate: 20)
        let legacyInt = Key<GlobalNamespace, NSNumber>(id: "int", defaultValue: .init(value: 1))
        let legacyDouble = Key<GlobalNamespace, NSNumber>(id: "dbl", defaultValue: .init(value: 1.2))
        let legacyBool = Key<GlobalNamespace, NSNumber>(id: "bol", defaultValue: .init(value: true))
        let legacyString = Key<GlobalNamespace, NSString>(id: "str", defaultValue: "yes")
        let legacyDate = Key<GlobalNamespace, NSDate>(id: "dat", defaultValue: refDate)
        let legacyOptional = Key<GlobalNamespace, NSString?>(id: "opt", defaultValue: nil)
        // codable keys
        let int = Key<GlobalNamespace, Int>(id: "int", defaultValue: 2)
        let double = Key<GlobalNamespace, Double>(id: "dbl", defaultValue: 2.2)
        let bool = Key<GlobalNamespace, Bool>(id: "bol", defaultValue: false)
        let string = Key<GlobalNamespace, String>(id: "str", defaultValue: "no")
        let date = Key<GlobalNamespace, Date>(id: "dat", defaultValue: Date())
        let optional = Key<GlobalNamespace, String?>(id: "opt", defaultValue: nil)

        // write to legacy keys
        store.set(legacyInt, value: legacyInt.defaultValue)
        store.set(legacyDouble, value: legacyDouble.defaultValue)
        store.set(legacyBool, value: legacyBool.defaultValue)
        store.set(legacyString, value: legacyString.defaultValue)
        store.set(legacyDate, value: legacyDate.defaultValue)
        store.set(legacyOptional, value: "some")

        // read from codable keys
        XCTAssertEqual(store.get(int), legacyInt.defaultValue.intValue)
        XCTAssertEqual(store.get(double), legacyDouble.defaultValue.doubleValue)
        XCTAssertEqual(store.get(bool), legacyBool.defaultValue.boolValue)
        XCTAssertEqual(store.get(string), legacyString.defaultValue as String)
        XCTAssertEqual(store.get(date), legacyDate.defaultValue as Date)
        XCTAssertEqual(store.get(optional), "some")
    }
}
