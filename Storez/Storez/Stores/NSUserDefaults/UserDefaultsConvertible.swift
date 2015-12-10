//
//  UserDefaultsConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//


/** See ConvertibleValue for more information
*/
public protocol UserDefaultsConvertible {
    typealias UserDefaultsType: UserDefaultsSupportedType

    static func decode(userDefaultsValue value: UserDefaultsType) -> Self?
    var encodeForUserDefaults: UserDefaultsType? { get }
}


struct UserDefaultsConvertibleBox <T: UserDefaultsConvertible>: UserDefaultsAcceptedType {
    
    let value: T?
    
    var supportedType: UserDefaultsSupportedType? {
        return value?.encodeForUserDefaults
    }
    
    init(storedValue: T.UserDefaultsType?) {
        
        if let storedValue = storedValue {
            value = T.decode(userDefaultsValue: storedValue)
        }
        else {
            value = nil
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
}

