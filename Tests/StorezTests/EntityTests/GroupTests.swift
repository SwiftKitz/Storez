//
//  NamespaceTests.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/19/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import XCTest
@testable import Storez


class NamespaceTests: XCTestCase {
    
    func testSingleKey() {
        XCTAssertEqual(TestNamespace.key, TestNamespace.id)
    }
    
    func testNestedKeys() {
        
        let expectedKey = [ChildNamespace.parent.key, ChildNamespace.id].joined(separator: ":")
        XCTAssertEqual(ChildNamespace.key, expectedKey)
    }
}
