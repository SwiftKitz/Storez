//
//  UserDefaultsConvertible+Foundation.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation


// FIXME: Protocol extensions can't have inheritence clause

extension NSCoding {
    
    var encode: NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
}

extension NSData {
    
    func decode<T>() -> T? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(self) as? T
    }
}

