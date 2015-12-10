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
    
    let value: T?
    
    var supportedType: UserDefaultsSupportedType? {
        return value
    }
    
    init(storedValue: T?) {
        value = storedValue
    }
    
    init(_ value: T?) {
        self.value = value
    }
}
