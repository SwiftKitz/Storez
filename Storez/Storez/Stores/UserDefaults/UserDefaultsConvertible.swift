//
//  UserDefaultsConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation

/** See ConvertibleValue for more information
*/
public protocol UserDefaultsConvertible {
    associatedtype UserDefaultsType: UserDefaultsSupportedType

    static func decode(userDefaultsValue value: UserDefaultsType) -> Self?
    var encodeForUserDefaults: UserDefaultsType? { get }
}


struct UserDefaultsConvertibleBox <T: UserDefaultsConvertible>: UserDefaultsTransaction {
    
    let value: T
    
    var supportedType: Data? {
        return value.encodeForUserDefaults?.encode as Data?
    }
    
    init?(storedValue: Data?) {
        
        guard let storedValue: T.UserDefaultsType = storedValue?.decode(),
            let value = T.decode(userDefaultsValue: storedValue)
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
