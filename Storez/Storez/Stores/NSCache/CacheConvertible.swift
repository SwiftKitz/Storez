//
//  CacheConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/9/15.
//  Copyright © 2015 mazy. All rights reserved.
//

/** See ConvertibleValue for more info
*/
protocol CacheConvertible: ConvertibleValue {
    typealias UnderlyingType: CacheSupportedType
}
