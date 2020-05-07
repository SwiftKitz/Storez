//
//  Key.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//


public struct Key<G: Namespace, V>: KeyType {
    
    public typealias NamespaceType = G
    public typealias ValueType = V
    
    public typealias ChangeBlock = (ValueType) -> (ValueType)
    
    
    public var id: String
    public var defaultValue: ValueType
    public var changeBlock: ChangeBlock?
    
    public var stringValue: String {
        return [NamespaceType.key, id].joined(separator: ":")
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
    
    public func processChange(_ oldValue: ValueType, newValue: ValueType) -> ValueType {
        return changeBlock?(newValue) ?? newValue
    }
}
