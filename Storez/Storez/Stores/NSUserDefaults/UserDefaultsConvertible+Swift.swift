//
//  UserDefaultsConvertible+Swift.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation

/**
    Adding support to Swift types
*/
extension Int: UserDefaultsConvertible {
    
    public typealias UnderlyingType = NSNumber
    
    public static func decode(value: UnderlyingType) -> Int? {
        return value.integerValue
    }
    
    public var encode: UnderlyingType? {
        return NSNumber(integer: self)
    }
}

extension Double: UserDefaultsConvertible {
    
    public typealias UnderlyingType = NSNumber
    
    public static func decode(value: UnderlyingType) -> Double? {
        return value.doubleValue
    }
    
    public var encode: UnderlyingType? {
        return NSNumber(double: self)
    }
}

extension Bool: UserDefaultsConvertible {
    
    public typealias UnderlyingType = NSNumber
    
    public static func decode(value: UnderlyingType) -> Bool? {
        return value.boolValue
    }
    
    public var encode: UnderlyingType? {
        return NSNumber(bool: self)
    }
}

extension Float: UserDefaultsConvertible {
    
    public typealias UnderlyingType = NSNumber
    
    public static func decode(value: UnderlyingType) -> Float? {
        return value.floatValue
    }
    
    public var encode: UnderlyingType? {
        return NSNumber(float: self)
    }
}

extension String: UserDefaultsConvertible {
    
    public typealias UnderlyingType = NSString
    
    public static func decode(value: UnderlyingType) -> String? {
        return value as String
    }
    
    public var encode: UnderlyingType? {
        return self as NSString
    }
}

