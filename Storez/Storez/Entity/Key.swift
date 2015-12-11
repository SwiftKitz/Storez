//
//  Key.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//


public struct Key<G: Group, V>: KeyType {
    
    public typealias GroupType = G
    public typealias ValueType = V
    
    public typealias ChangeBlock = (ValueType) -> (ValueType)
    
    
    public var id: String
    public var defaultValue: ValueType
    public var changeBlock: ChangeBlock?
    
    public var stringValue: String {
        return [GroupType.key, id].joinWithSeparator(":")
    }
    
    // MARK: - Init & Dealloc
    
    public init(
        id: String,
        defaultValue: ValueType,
        changeBlock: ChangeBlock? = nil
    )
    {
        self.id = id
        self.defaultValue = defaultValue
        self.changeBlock = changeBlock
    }
    
    public func processChange(oldValue: ValueType, newValue: ValueType) -> ValueType {
        return changeBlock?(newValue) ?? newValue
    }
}
