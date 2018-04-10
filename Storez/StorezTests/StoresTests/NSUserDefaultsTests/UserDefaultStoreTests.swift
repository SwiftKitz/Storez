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
    
    let store = UserDefaultsStore(suite: "io.kitz.storez.test-\(arc4random_uniform(999_999_999))")
    
    
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
    
    func testGetterPerformance() {
        
        self.measure {
            let _ = self.store.get(TestNamespace.anyKey)
        }
    }
    
    func testSetterPerformance() {
        
        self.measure {
            self.store.set(TestNamespace.anyKey, value: "more testing")
        }
    }
    
}
