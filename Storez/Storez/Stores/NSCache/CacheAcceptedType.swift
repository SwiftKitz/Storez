//
//  CacheAcceptedType.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/11/15.
//  Copyright © 2015 mazy. All rights reserved.
//

protocol CacheAcceptedType {
    
    typealias ValueType
    
    var supportedType: AnyObject? { get }
    var value: ValueType { get }
    
    init?(storedValue: AnyObject?)
    init(_ value: ValueType)
}
