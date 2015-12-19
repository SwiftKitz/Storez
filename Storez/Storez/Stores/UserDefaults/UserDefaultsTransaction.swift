//
//  UserDefaultsTransaction.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/11/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation

protocol UserDefaultsTransaction {
    
    typealias ValueType
    
    var supportedType: NSData? { get }
    var value: ValueType { get }
    
    init?(storedValue: NSData?)
    init(_ value: ValueType)
}
