//
//  UserDefaultsConvertible+Foundation.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation


// FIXME: Protocol extensions can't have inheritence clause
public extension NSCoding {
    
    public typealias UnderlyingType = NSData
    
    public static func decode(value: UnderlyingType) -> Self? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(value) as? Self
    }
    
    public var encode: UnderlyingType {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
}

