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
        
        let nullableKey = Key<GlobalGroup, NSDate?>(id: "nullable-date", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableKey), nil)
        store.set(nullableKey, value: date)
        XCTAssertEqual(store.get(nullableKey), date)
        
        let defaultDate = NSDate(timeIntervalSinceReferenceDate: 0)
        let nonnullKey = Key<GlobalGroup, NSDate>(id: "nonnull-date", defaultValue: defaultDate)
        
        XCTAssertEqual(store.get(nonnullKey), defaultDate)
        store.set(nonnullKey, value: date)
        XCTAssertEqual(store.get(nonnullKey), date)
    }
    
    func testSwiftType() {
        
        let nullableKey = Key<GlobalGroup, String?>(id: "nullable-string", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableKey), nil)
        store.set(nullableKey, value: "test")
        XCTAssertEqual(store.get(nullableKey), "test")
        
        let nonnullKey = Key<GlobalGroup, String>(id: "nonnull-string", defaultValue: "string")
        
        XCTAssertEqual(store.get(nonnullKey), "string")
        store.set(nonnullKey, value: "blah")
        XCTAssertEqual(store.get(nonnullKey), "blah")
    }
    
    func testCustomObject() {
        
        let object = CustomObject(title: "custom", year: 1993)
        
        let nullableKey = Key<GlobalGroup, CustomObject?>(id: "nullable-custom", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableKey), nil)
        store.set(nullableKey, value: object)
        XCTAssertEqual(store.get(nullableKey), object)
        
        let nonnullKey = Key<GlobalGroup, CustomObject>(id: "nonnull-custom", defaultValue: CustomObject())
        
        XCTAssertEqual(store.get(nonnullKey), CustomObject())
        store.set(nonnullKey, value: object)
        XCTAssertEqual(store.get(nonnullKey), object)
    }
}
