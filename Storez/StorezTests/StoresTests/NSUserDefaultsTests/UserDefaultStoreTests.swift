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
    
    let store = UserDefaultsStore(suite: "io.kitz.storez.test")
    
    
    override func setUp() {
        super.setUp()
        
        store.clear()
    }
    
    func testUserDefaultValueTypes() {
        
        let arrayEntry = Entry<GlobalGroup, NSArray>(id: "array", defaultValue: [1])
        let array: NSArray = [1, 2, 3]
        
        XCTAssertEqual(store.get(arrayEntry), [1])
        store.set(arrayEntry, value: array)
        XCTAssertEqual(store.get(arrayEntry), array)
        
        let dateEntry = Entry<GlobalGroup, NSDate?>(id: "date", defaultValue: nil)
        let date = NSDate(timeIntervalSinceReferenceDate: 500)
        
        XCTAssertEqual(store.get(dateEntry), nil)
        store.set(dateEntry, value: date)
        XCTAssertEqual(store.get(dateEntry), date)
    }
    
    func testNSCodingConformingTypes() {
        
        let uuidEntry = Entry<GlobalGroup, NSUUID?>(id: "uuid", defaultValue: nil)
        let uuid = NSUUID()
        
        XCTAssertEqual(store.get(uuidEntry), nil)
        store.set(uuidEntry, value: uuid)
        XCTAssertEqual(store.get(uuidEntry), uuid)
    }
    
    func testPrimitiveTypes() {
        
        let value = 20.4
        let primitive = Entry<GlobalGroup, Double?>(id: "primitive", defaultValue: nil)
        
        XCTAssertEqual(store.get(primitive), nil)
        store.set(primitive, value: value)
        XCTAssertEqual(store.get(primitive), value)
    }
    
    func testStringType() {
        
        let text = Entry<GlobalGroup, String>(id: "text", defaultValue: "default")
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
        
        let customEntry = Entry<GlobalGroup, CustomObject?>(id: "custom-object", defaultValue: nil)
        
        store.set(customEntry, value: value)
        XCTAssertEqual(store.get(customEntry), value)
    }
    
    func testDefaultValueIsResolved() {
        
        let defaultValue = "default-value"
        let defaultProvider = Entry<GlobalGroup, String>(id: "default-provider", defaultValue: defaultValue)
        
        let value = store.get(defaultProvider)
        XCTAssertEqual(value, defaultValue)
    }
    
    func testChangeBlockIsTriggered() {
        
        let changingEntry = Entry<GlobalGroup, String?>(id: "changing-object", defaultValue: nil) {
            return [$0, "Heisenburg"].flatMap { $0 }.joinWithSeparator(" ")
        }

        store.set(changingEntry, value: "say my name!")
        XCTAssertEqual(store.get(changingEntry), "say my name! Heisenburg")
    }
    
    func testPreCommitHook() {
        
        TestGroup.preCommitCalls = 0
        
        store.set(TestGroup.anyEntry, value: "new value")
        XCTAssertEqual(TestGroup.preCommitCalls, 1)
    }
    
    func testPostCommitHook() {
        
        TestGroup.postCommitCalls = 0
        
        store.set(TestGroup.anyEntry, value: "test")
        XCTAssertEqual(TestGroup.postCommitCalls, 1)
    }
    
    func testGetterPerformance() {
        
        self.measureBlock {
            self.store.get(TestGroup.anyEntry)
        }
    }
    
    func testSetterPerformance() {
        
        self.measureBlock {
            self.store.set(TestGroup.anyEntry, value: "more testing")
        }
    }
    
}
