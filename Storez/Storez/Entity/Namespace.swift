//
//  Namespace.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

/** We use Identifiable protocol to break nested types
*/
public protocol Identifiable {
    static var id: String { get }
}

/** A Namespace is just a namespace to group a collection of
    `Key` objects together.
*/
public protocol Namespace: Identifiable {
    
    associatedtype parent: Identifiable = GlobalNamespace
    
    static func preCommitHook()     /* Optional */
    static func postCommitHook()    /* Optional */
}

public extension Namespace {

    static var key: String {
        
        return [parent.id, id]
            .filter { !$0.isEmpty }
            .joined(separator: ":")
    }
    
    static func preCommitHook() {}
    static func postCommitHook() {}
}

// Convenience Global group

public struct GlobalNamespace: Namespace {
    public static let id = ""
}
