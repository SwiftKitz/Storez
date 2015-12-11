//
//  KeyTypeTests.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/11/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import XCTest
import Storez


private struct Key: KeyType {
    typealias NamespaceType = GlobalNamespace
    typealias ValueType = Int
    
    var stringValue: String { return "key" }
    var defaultValue: ValueType { return 0 }
}

class KeyTypeTests: XCTestCase {
    
    func testDefaultProcessChange() {
        
        let key = Key()
        XCTAssertEqual(key.processChange(0, newValue: 1), 1)
    }
}
