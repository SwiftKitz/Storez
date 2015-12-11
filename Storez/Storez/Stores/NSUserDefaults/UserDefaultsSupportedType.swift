//
//  UserDefaultsSupportedType.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/6/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


/** To reduce complexity, we simply allow all types that
    can convert using NSCoding
*/
public typealias UserDefaultsSupportedType = NSCoding


struct UserDefaultsSupportedTypeBox <T: UserDefaultsSupportedType>: UserDefaultsAcceptedType {
    
    let value: T
    
    var supportedType: NSData? {
        return value.encode
    }
    
    init?(storedValue: NSData?) {
        
        guard let value: T = storedValue?.decode() else {
            return nil
        }
        
        self.value = value
    }
    
    init(_ value: T) {
        self.value = value
    }
}

struct UserDefaultsNullableSupportedTypeBox <T: Nullable where T.UnderlyingType: UserDefaultsSupportedType>: UserDefaultsAcceptedType {
    
    let value: T
    
    var supportedType: NSData? {
        return value.wrappedValue?.encode
    }
    
    init?(storedValue: NSData?) {
        
        guard let data = storedValue, let value: T.UnderlyingType = data.decode() else {
            return nil
        }
        
        self.value = T(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}
