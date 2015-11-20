//
//  TestGroup.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Storez


struct TestGroup: Group {
    
    static let id = "testgroup"
    
    static let AnyEntry = Entry<TestGroup, String?>(id: "any-entry", defaultValue: nil)
}

struct ChildGroup: Group {
    
    typealias Parent = TestGroup
    
    static let id = "child-group"
}

