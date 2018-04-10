//
//  CacheStoreTests.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/9/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import XCTest
@testable import Storez


class CacheStoreTests: XCTestCase {
    
    let store = CacheStore()
    
    override func setUp() {
        super.setUp()
        
        store.clear()
    }
    
    func testCacheType() {
        
        let date = NSDate(timeIntervalSinceReferenceDate: 100)
        
        let nullableKey = Key<GlobalNamespace, NSDate?>(id: "nullable-date", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableKey), nil)
        store.set(nullableKey, value: date)
        XCTAssertEqual(store.get(nullableKey), date)
        
        let defaultDate = NSDate(timeIntervalSinceReferenceDate: 0)
        let nonnullKey = Key<GlobalNamespace, NSDate>(id: "nonnull-date", defaultValue: defaultDate)
        
        XCTAssertEqual(store.get(nonnullKey), defaultDate)
        store.set(nonnullKey, value: date)
        XCTAssertEqual(store.get(nonnullKey), date)
    }
    
    func testSwiftType() {
        
        let nullableKey = Key<GlobalNamespace, String?>(id: "nullable-string", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableKey), nil)
        store.set(nullableKey, value: "test")
        XCTAssertEqual(store.get(nullableKey), "test")
        
        let nonnullKey = Key<GlobalNamespace, String>(id: "nonnull-string", defaultValue: "string")
        
        XCTAssertEqual(store.get(nonnullKey), "string")
        store.set(nonnullKey, value: "blah")
        XCTAssertEqual(store.get(nonnullKey), "blah")
    }
    
    func testCustomObject() {
        
        let object = CustomObject(title: "custom", year: 1993)
        
        let nullableKey = Key<GlobalNamespace, CustomObject?>(id: "nullable-custom", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableKey), nil)
        store.set(nullableKey, value: object)
        XCTAssertEqual(store.get(nullableKey), object)
        
        let nonnullKey = Key<GlobalNamespace, CustomObject>(id: "nonnull-custom", defaultValue: CustomObject())
        
        XCTAssertEqual(store.get(nonnullKey), CustomObject())
        store.set(nonnullKey, value: object)
        XCTAssertEqual(store.get(nonnullKey), object)
    }
    
    func testNil() {
        
        // setting nil should delete the record
        let nullableKey = Key<GlobalNamespace, String?>(id: "nil", defaultValue: nil)
        
        store.set(nullableKey, value: "hello, world!")
        store.set(nullableKey, value: nil)
        XCTAssertEqual(store.get(nullableKey), nil)
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
