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
        
        let nullableEntry = Entry<GlobalGroup, NSDate?>(id: "nullable-date", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableEntry), nil)
        store.set(nullableEntry, value: date)
        XCTAssertEqual(store.get(nullableEntry), date)
        
        let defaultDate = NSDate(timeIntervalSinceReferenceDate: 0)
        let nonnullEntry = Entry<GlobalGroup, NSDate>(id: "nonnull-date", defaultValue: defaultDate)
        
        XCTAssertEqual(store.get(nonnullEntry), defaultDate)
        store.set(nonnullEntry, value: date)
        XCTAssertEqual(store.get(nonnullEntry), date)
    }
    
    func testSwiftType() {
        
        let nullableEntry = Entry<GlobalGroup, String?>(id: "nullable-string", defaultValue: nil)
        
        XCTAssertEqual(store.get(nullableEntry), nil)
        store.set(nullableEntry, value: "test")
        XCTAssertEqual(store.get(nullableEntry), "test")
        
        let nonnullEntry = Entry<GlobalGroup, String>(id: "nonnull-string", defaultValue: "string")
        
        XCTAssertEqual(store.get(nonnullEntry), "string")
        store.set(nonnullEntry, value: "blah")
        XCTAssertEqual(store.get(nonnullEntry), "blah")
    }
}
