//
//  EntryType.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/19/15.
//  Copyright © 2015 mazy. All rights reserved.
//


/** Allows you to use your own conforming Entry types
*/
public protocol EntryType {
    
    typealias GroupType: Group
    typealias ValueType
    
    var key: String { get }
    var defaultValue: ValueType { get }
    
    /* optional */
    func willChange(oldValue: ValueType, newValue: ValueType)
    func processChange(oldValue: ValueType, newValue: ValueType) -> ValueType
    func didChange(oldValue: ValueType, newValue: ValueType)
}

public extension EntryType {
    
    func willChange(oldValue: ValueType, newValue: ValueType) {}
    func processChange(oldValue: ValueType, newValue: ValueType) -> ValueType { return newValue }
    func didChange(oldValue: ValueType, newValue: ValueType) {}
}
