//
//  StorezTests.swift
//  StorezTests
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import XCTest
import Storez


// FIXME: Defining this within a function doesn't compile
private struct AnyGroup: Group {
    
    static var called = false
    static let id = "any-group"
    
    static func postCommitHook() {
        called = true
    }
}


class UserDefaultsStoreTests: XCTestCase {
    
    let store = UserDefaultsStore(suite: "io.kitz.storez.test")
    
    
    override func setUp() {
        super.setUp()
        
        store.clear()
    }
    
    func testUserDefaultValueTypes() {
        
        let arrayEntry = Entry<TestGroup, NSArray>(id: "array", defaultValue: [1])
        let array: NSArray = [1, 2, 3]
        
        XCTAssertEqual(store.get(arrayEntry), [1])
        store.set(arrayEntry, value: array)
        XCTAssertEqual(store.get(arrayEntry), array)
        
        let dateEntry = Entry<TestGroup, NSDate?>(id: "date", defaultValue: nil)
        let date = NSDate(timeIntervalSinceReferenceDate: 500)
        
        XCTAssertEqual(store.get(dateEntry), nil)
        store.set(dateEntry, value: date)
        XCTAssertEqual(store.get(dateEntry), date)
    }
    
    func testNSCodingTypes() {
        
        let uuidEntry = Entry<TestGroup, NSUUID?>(id: "uuid", defaultValue: nil)
        let uuid = NSUUID()
        
        XCTAssertEqual(store.get(uuidEntry), nil)
        store.set(uuidEntry, value: uuid)
        XCTAssertEqual(store.get(uuidEntry), uuid)
    }
    
    func testPrimitiveStorage() {
        
        let value = 20.4
        let primitive = Entry<TestGroup, Double?>(id: "primitive", defaultValue: nil)
        
        store.set(primitive, value: value)
        XCTAssertEqual(store.get(primitive), value)
    }
    
    func testStringStorage() {
        
        let text = Entry<TestGroup, String?>(id: "text", defaultValue: nil)
        let value = "testing-string-🇦🇪"
        
        store.set(text, value: value)
        XCTAssertEqual(store.get(text), value)
    }
    
    func testCustomObjectStorage() {
        
        let value = CustomObject(
            title: "Sherlock Holmes",
            year: 1886
        )
        
        let customEntry = Entry<TestGroup, CustomObject?>(id: "custom-object", defaultValue: nil)
        
        store.set(customEntry, value: value)
        XCTAssertEqual(store.get(customEntry), value)
    }
    
    func testDefaultValueIsResolved() {
        
        let defaultValue = "default-value"
        let defaultProvider = Entry<TestGroup, String>(id: "default-provider", defaultValue: defaultValue)
        
        let value = store.get(defaultProvider)
        XCTAssertEqual(value, defaultValue)
    }
    
    func testChangeBlockIsTriggered() {
        
        let changingEntry = Entry<TestGroup, String?>(id: "changing-object", defaultValue: nil) {
            return [$0, "Heisenburg"].flatMap { $0 }.joinWithSeparator(" ")
        }

        store.set(changingEntry, value: "what's my name?")
        XCTAssertEqual(store.get(changingEntry), "what's my name? Heisenburg")
    }
    
    func testPostCommitHook() {
        
        AnyGroup.called = false
        let anyEntry = Entry<AnyGroup, String?>(id: "any-entry", defaultValue: nil)
        
        store.set(anyEntry, value: "test")
        XCTAssertTrue(AnyGroup.called)
    }
    
    func testGetterPerformance() {
        
        self.measureBlock {
            self.store.get(TestGroup.AnyEntry)
        }
    }
    
    func testSetterPerformance() {
        
        self.measureBlock {
            self.store.set(TestGroup.AnyEntry, value: "more testing")
        }
    }
    
}
