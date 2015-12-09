//
//  CacheSupportedType.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/8/15.
//  Copyright © 2015 mazy. All rights reserved.
//

public protocol CacheSupportedType {
    var anyObject: AnyObject { get }
}

public extension CacheSupportedType where Self: AnyObject {
    
    var anyObject: AnyObject {
        return self
    }
}
