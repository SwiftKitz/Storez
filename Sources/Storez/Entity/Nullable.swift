//
//  Nullable.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/11/15.
//  Copyright © 2015 mazy. All rights reserved.
//

public protocol Nullable {
    associatedtype UnderlyingType
    
    var wrappedValue: UnderlyingType? { get }
    
    init(_ some: UnderlyingType)
}

extension Optional: Nullable {
    public typealias UnderlyingType = Wrapped
    
    public var wrappedValue: UnderlyingType? {
        return map { $0 }
    }
}
