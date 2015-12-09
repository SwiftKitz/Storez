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
    
    func testAnyObjectType() {
        
        let date = NSDate(timeIntervalSinceReferenceDate: 100)
        let defaultDate = NSDate(timeIntervalSinceReferenceDate: 0)
        let entry = Entry<GlobalGroup, NSDate>(id: "date", defaultValue: defaultDate)
        
        XCTAssertEqual(store.get(entry), defaultDate)
        store.set(entry, value: date)
        XCTAssertEqual(store.get(entry), date)
    }
    
    func testSwiftType() {
        
        let entry = Entry<GlobalGroup, String?>(id: "string", defaultValue: nil)
        
        XCTAssertEqual(store.get(entry), nil)
        store.set(entry, value: "test")
        XCTAssertEqual(store.get(entry), "test")
    }
    
    
}
