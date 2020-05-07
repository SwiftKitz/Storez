//
//  UserDefaultsTransaction.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/11/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation

protocol UserDefaultsTransaction {
    
    associatedtype ValueType
    
    var supportedType: Data? { get }
    var value: ValueType { get }
    
    init?(storedValue: Data?)
    init(_ value: ValueType)
}
