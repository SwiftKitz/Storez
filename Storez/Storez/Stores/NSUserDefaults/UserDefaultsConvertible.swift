//
//  UserDefaultsConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//


/** Other types can conform to this protocol to add  support.
    It simply requires the class to convert to and from one of
    the supported types.
*/
public protocol UserDefaultsConvertible {

    typealias UnderlyingType: UserDefaultsSerializable
    
    static func decode(value: UnderlyingType) -> Self?
    var encode: UnderlyingType? { get }
}

