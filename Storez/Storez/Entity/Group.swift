//
//  Group.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

/** We use Namespace protocol to break nested types
*/
public protocol Namespace {
    static var id: String { get }
}

public struct GlobalNamespace: Namespace {
    public static let id = ""
}

/** A Group is just a namespace to group a collection of
    `Entry` objects together.
*/
public protocol Group: Namespace {
    
    typealias Parent: Namespace = GlobalNamespace
    
    static func preCommitHook()     /* Optional */
    static func postCommitHook()    /* Optional */
}

public extension Group {

    static var key: String {
        
        return [Parent.id, id]
            .filter { !$0.isEmpty }
            .joinWithSeparator(":")
    }
    
    static func preCommitHook() {}
    static func postCommitHook() {}
}

// Convenience Global group

public struct GlobalGroup: Group {
    public static let id = ""
}
