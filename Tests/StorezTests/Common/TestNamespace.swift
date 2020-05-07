//
//  TestNamespace.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Storez


struct TestNamespace: Namespace {
    
    static let id = "testgroup"
    
    static let anyKey = Key<TestNamespace, String?>(id: "any-key", defaultValue: nil)
    
    static var preCommitCalls = 0
    static func preCommitHook() {
        preCommitCalls += 1
    }
    
    static var postCommitCalls = 0
    static func postCommitHook() {
        postCommitCalls += 1
    }
}

struct ChildNamespace: Namespace {
    
    typealias parent = TestNamespace
    
    static let id = "child-group"
}

