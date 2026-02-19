//
//  CustomObject.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/6/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation
import Storez


struct CustomObject: Equatable {
    
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


extension CustomObject: UserDefaultsConvertible {
    
    static func decode(userDefaultsValue value: NSDictionary) -> CustomObject? {

        guard let title = value["title"] as? String,
              let year = value["year"] as? Int
        else {
            return nil
        }

        return CustomObject(title: title, year: year)
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
        guard let dict = value as? NSDictionary else { return nil }
        return decode(userDefaultsValue: dict)
    }
    
    var encodeForCache: AnyObject? {
        return encodeForUserDefaults
    }
}
