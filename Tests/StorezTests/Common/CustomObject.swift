//
//  CustomObject.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/6/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation
import Storez


struct CustomObject {
    
    let title: String
    let year: Int
    
    init() {
        
        title = ""
        year = 0
    }
    
    init(title: String, year: Int) {
        
        self.title = title
        self.year = year
    }
}

extension CustomObject: Equatable {
    static func ==(lhs: CustomObject, rhs: CustomObject) -> Bool {
        return lhs.title == rhs.title && lhs.year == rhs.year
    }
}


extension CustomObject: UserDefaultsConvertible {
    
    static func decode(userDefaultsValue value: NSDictionary) -> CustomObject? {
        
        return CustomObject(
            title: value["title"] as! String,
            year: value["year"] as! Int
        )
    }
    
    var encodeForUserDefaults: NSDictionary? {
        return [
            "title": title,
            "year": year,
        ]
    }
}

extension CustomObject: CacheConvertible {
    
    static func decode(cacheValue value: AnyObject) -> CustomObject? {
        return decode(userDefaultsValue: value as! NSDictionary)
    }
    
    var encodeForCache: AnyObject? {
        return encodeForUserDefaults
    }
}
