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

    var encode: Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension Data {

    func decode<T>() -> T? {
        guard let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: self) else {
            return nil
        }
        unarchiver.requiresSecureCoding = false
        return unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? T
    }
}

