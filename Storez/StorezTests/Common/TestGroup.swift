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
    
    static let anyKey = Key<TestGroup, String?>(id: "any-key", defaultValue: nil)
    
    static var preCommitCalls = 0
    static func preCommitHook() {
        preCommitCalls += 1
    }
    
    static var postCommitCalls = 0
    static func postCommitHook() {
        postCommitCalls += 1
    }
}

struct ChildGroup: Group {
    
    typealias parent = TestGroup
    
    static let id = "child-group"
}

