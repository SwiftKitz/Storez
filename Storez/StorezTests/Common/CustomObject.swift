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
    
    typealias UnderlyingType = NSDictionary

    static func decode(value: UnderlyingType) -> CustomObject? {
        
        return CustomObject(
            title: value["title"] as! String,
            year: value["year"] as! Int
        )
    }
    
    var encode: UnderlyingType? {
        return [
            "title": title,
            "year": year,
        ]
    }
}
