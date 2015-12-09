//
//  UserDefaultsConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//


/** See ConvertibleValue for more information
*/
public protocol UserDefaultsConvertible: ConvertibleValue {
    typealias UnderlyingType: UserDefaultsSupportedType
}

