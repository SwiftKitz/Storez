//
//  CacheConvertible+Swift.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/9/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation

/** Adding support to Swift types
*/
extension Optional: UserDefaultsConvertible where Wrapped: UserDefaultsConvertible {

    public typealias UserDefaultsValueType = Wrapped
    public typealias UserDefaultsType = Wrapped.UserDefaultsType

    public static func decode(userDefaultsValue value: Wrapped.UserDefaultsType) -> Optional<Wrapped>? {
        return Wrapped.decode(userDefaultsValue: value)
    }

    public var encodeForUserDefaults: Wrapped.UserDefaultsType? {
        return wrappedValue?.encodeForUserDefaults
    }
}

extension Int: CacheConvertible {
    
    public typealias CacheType = AnyObject
    
    public static func decode(cacheValue value: CacheType) -> Int? {
        return value as? Int
    }
    
    public var encodeForCache: CacheType? {
        return self as AnyObject
    }
}

extension Double: CacheConvertible {
    
    public typealias CacheType = AnyObject
    
    public static func decode(cacheValue value: CacheType) -> Double? {
        return value as? Double
    }
    
    public var encodeForCache: CacheType? {
        return self as AnyObject
    }
}

extension Bool: CacheConvertible {
    
    public typealias CacheType = AnyObject
    
    public static func decode(cacheValue value: CacheType) -> Bool? {
        return value as? Bool
    }
    
    public var encodeForCache: CacheType? {
        return self as AnyObject
    }
}

extension Float: CacheConvertible {
    
    public typealias CacheType = AnyObject
    
    public static func decode(cacheValue value: CacheType) -> Float? {
        return value as? Float
    }
    
    public var encodeForCache: CacheType? {
        return self as AnyObject
    }
}

extension String: CacheConvertible {
    
    public typealias CacheType = AnyObject
    
    public static func decode(cacheValue value: CacheType) -> String? {
        return value as? String
    }
    
    public var encodeForCache: CacheType? {
        return self as AnyObject
    }
}

