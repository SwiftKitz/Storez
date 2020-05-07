//
//  KeyTests.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/19/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import XCTest
@testable import Storez


class StoreTests: XCTestCase {
    
    func testStringValue() {
        
        let id = "key-id"
        let key = Key<ChildNamespace, Void?>(id: id, defaultValue: nil)
        
        XCTAssertEqual(key.stringValue, [ChildNamespace.key, key.id].joined(separator: ":"))
    }
}
