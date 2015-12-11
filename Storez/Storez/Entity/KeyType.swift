//
//  KeyType.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/19/15.
//  Copyright © 2015 mazy. All rights reserved.
//


/** Allows you to use your own conforming Key types
*/
public protocol KeyType {
    
    typealias GroupType: Group
    typealias ValueType
    
    var stringValue: String { get }
    var defaultValue: ValueType { get }
    
    /* optional */
    func willChange(oldValue: ValueType, newValue: ValueType)
    func processChange(oldValue: ValueType, newValue: ValueType) -> ValueType
    func didChange(oldValue: ValueType, newValue: ValueType)
}

public extension KeyType {
    
    func willChange(oldValue: ValueType, newValue: ValueType) {}
    func processChange(oldValue: ValueType, newValue: ValueType) -> ValueType { return newValue }
    func didChange(oldValue: ValueType, newValue: ValueType) {}
}
