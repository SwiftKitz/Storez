//
//  UserDefaultsSerializable.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/6/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


/** Types conforming to this protocol are supported by
    NSUserDefaults.
*/
public protocol UserDefaultsSerializable {
    var anyObject: AnyObject { get }
}

public extension UserDefaultsSerializable where Self: AnyObject {
    
    var anyObject: AnyObject {
        return self
    }
}

// NSUserDefaults Supported Types
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html
extension NSArray: UserDefaultsSerializable {}
extension NSDictionary: UserDefaultsSerializable {}

extension NSDate: UserDefaultsSerializable {}
extension NSData: UserDefaultsSerializable {}
extension NSNumber: UserDefaultsSerializable {}
extension NSString: UserDefaultsSerializable {}

