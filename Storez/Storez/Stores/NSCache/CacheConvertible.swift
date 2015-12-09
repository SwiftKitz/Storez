//
//  CacheConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/9/15.
//  Copyright © 2015 mazy. All rights reserved.
//

/** See ConvertibleValue for more info
*/
public protocol CacheConvertible {
    
    typealias CacheType: CacheSupportedType
    
    static func decode(cacheValue value: CacheType) -> Self?
    var encodeForCache: CacheType? { get }
}
