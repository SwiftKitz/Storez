//
//  GroupTests.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/19/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import XCTest
@testable import Storez


class GroupTests: XCTestCase {
    
    func testSingleKey() {
        XCTAssertEqual(TestGroup.key, TestGroup.id)
    }
    
    func testNestedKeys() {
        
        let expectedKey = [ChildGroup.Parent.key, ChildGroup.id].joinWithSeparator(":")
        XCTAssertEqual(ChildGroup.key, expectedKey)
    }
}
