//
//  CacheTransaction.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/11/15.
//  Copyright © 2015 mazy. All rights reserved.
//

protocol CacheTransaction {
    
    associatedtype ValueType
    
    var supportedType: AnyObject? { get }
    var value: ValueType { get }
    
    init?(storedValue: AnyObject?)
    init(_ value: ValueType)
}
