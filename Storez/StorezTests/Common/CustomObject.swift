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
}

extension CustomObject: Equatable {}

func ==(lhs: CustomObject, rhs: CustomObject) -> Bool {
    return lhs.title == rhs.title && lhs.year == rhs.year
}


extension CustomObject: UserDefaultsConvertible {
    
    typealias UserDefaultsType = NSDictionary

    static func decode(userDefaultsValue value: UserDefaultsType) -> CustomObject? {
        
        return CustomObject(
            title: value["title"] as! String,
            year: value["year"] as! Int
        )
    }
    
    var encodeForUserDefaults: UserDefaultsType? {
        return [
            "title": title,
            "year": year,
        ]
    }
}
