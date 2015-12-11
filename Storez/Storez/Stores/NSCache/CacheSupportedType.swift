//
//  CacheSupportedType.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/8/15.
//  Copyright © 2015 mazy. All rights reserved.
//

/** NSCache only requires objects to conform to AnyObject
*/
public typealias CacheSupportedType = AnyObject


struct CacheSupportedBox <T: CacheSupportedType>: CacheAcceptedType {
    
    let value: T
    
    var supportedType: AnyObject? {
        // FIXME: Compiler crash
        let anyObject: AnyObject? = value
        return anyObject
    }
    
    init?(storedValue: AnyObject?) {
        
        guard let value = storedValue as? T else {
            return nil
        }
        
        self.value = value
    }
    
    init(_ value: T) {
        self.value = value
    }
}


struct CacheNullableSupportedBox <T: Nullable where T.UnderlyingType: CacheSupportedType>: CacheAcceptedType {
    
    let value: T
    
    var supportedType: AnyObject? {
        return value.wrappedValue
    }
    
    init?(storedValue: AnyObject?) {
        
        guard let value = storedValue as? T.UnderlyingType else {
                return nil
        }
        
        self.value = T(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}
