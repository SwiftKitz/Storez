//
//  ConvertibleValue.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/9/15.
//  Copyright © 2015 mazy. All rights reserved.
//

/** Implemented stores usually require their values to be of 
    specific type. In order to add support to other types we 
    provide this protocol to convert back and forth between the
    to be support type and a supported type.
*/
public protocol ConvertibleValue {
    
    typealias UnderlyingType
    
    static func decode(value: UnderlyingType) -> Self?
    var encode: UnderlyingType? { get }
}
