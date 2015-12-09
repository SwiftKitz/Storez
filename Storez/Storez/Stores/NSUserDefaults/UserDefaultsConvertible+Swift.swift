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
    
    public typealias UserDefaultsType = NSNumber
    
    public static func decode(userDefaultsValue value: UserDefaultsType) -> Int? {
        return value.integerValue
    }
    
    public var encodeForUserDefaults: UserDefaultsType? {
        return NSNumber(integer: self)
    }
}

extension Double: UserDefaultsConvertible {
    
    public typealias UserDefaultsType = NSNumber
    
    public static func decode(userDefaultsValue value: UserDefaultsType) -> Double? {
        return value.doubleValue
    }
    
    public var encodeForUserDefaults: UserDefaultsType? {
        return NSNumber(double: self)
    }
}

extension Bool: UserDefaultsConvertible {
    
    public typealias UserDefaultsType = NSNumber
    
    public static func decode(userDefaultsValue value: UserDefaultsType) -> Bool? {
        return value.boolValue
    }
    
    public var encodeForUserDefaults: UserDefaultsType? {
        return NSNumber(bool: self)
    }
}

extension Float: UserDefaultsConvertible {
    
    public typealias UserDefaultsType = NSNumber
    
    public static func decode(userDefaultsValue value: UserDefaultsType) -> Float? {
        return value.floatValue
    }
    
    public var encodeForUserDefaults: UserDefaultsType? {
        return NSNumber(float: self)
    }
}

extension String: UserDefaultsConvertible {
    
    public typealias UserDefaultsType = NSString
    
    public static func decode(userDefaultsValue value: UserDefaultsType) -> String? {
        return value as String
    }
    
    public var encodeForUserDefaults: UserDefaultsType? {
        return self as NSString
    }
}

