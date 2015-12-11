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
    
    func testKey() {
        
        let entryKey = "entry-key"
        let entry = Key<ChildGroup, Void?>(id: entryKey, defaultValue: nil)
        
        XCTAssertEqual(entry.key, [ChildGroup.key, entry.id].joinWithSeparator(":"))
    }
}
