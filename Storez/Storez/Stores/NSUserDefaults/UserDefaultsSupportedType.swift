//
//  UserDefaultsSupportedType.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/6/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


/** Types conforming to this protocol are supported by
    NSUserDefaults. They all conform to NSCoding, so we
    add that to avoid ambiguity when calling the 
    overloaded getters and setters
*/
public protocol UserDefaultsSupportedType: AnyObject, NSCoding {}

// NSUserDefaults Supported Types
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html
extension NSArray: UserDefaultsSupportedType {}
extension NSDictionary: UserDefaultsSupportedType {}

extension NSDate: UserDefaultsSupportedType {}
extension NSData: UserDefaultsSupportedType {}
extension NSNumber: UserDefaultsSupportedType {}
extension NSString: UserDefaultsSupportedType {}

