//
//  CacheConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/9/15.
//  Copyright © 2015 mazy. All rights reserved.
//

/** See ConvertibleValue for more info
*/
public protocol CacheConvertible {
    typealias CacheType: CacheSupportedType
    
    static func decode(cacheValue value: CacheType) -> Self?
    var encodeForCache: CacheType? { get }
}


struct CacheConvertibleBox <T: CacheConvertible>: CacheTransaction {
    
    let value: T
    
    var supportedType: AnyObject? {
        // FIXME: Compiler crash
        let anyObject: AnyObject? = value.encodeForCache
        return anyObject
    }
    
    init?(storedValue: AnyObject?) {
        
        guard let cacheValue = storedValue as? T.CacheType,
            let value = T.decode(cacheValue: cacheValue)
            else
        {
            return nil
        }
        
        self.value = value
    }
    
    init(_ value: T) {
        self.value = value
    }
}


struct CacheNullableConvertibleBox <T: Nullable where T.UnderlyingType: CacheConvertible>: CacheTransaction {
    
    let value: T
    
    var supportedType: AnyObject? {
        return value.wrappedValue?.encodeForCache
    }
    
    init?(storedValue: AnyObject?) {
        
        guard let cacheValue = storedValue as? T.UnderlyingType.CacheType,
            let value = T.UnderlyingType.decode(cacheValue: cacheValue)
            else {
                return nil
        }
        
        self.value = T(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}
