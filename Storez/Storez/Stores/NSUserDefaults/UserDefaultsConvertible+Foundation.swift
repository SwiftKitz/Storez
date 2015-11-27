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
    
    public var encode: NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
}

public extension NSData {
    
    public func decode<T>() -> T? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(self) as? T
    }
}

