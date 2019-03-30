//
//  UserDefaultsConvertible.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/18/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation

/** See ConvertibleValue for more information
*/
public protocol UserDefaultsConvertible {
    associatedtype UserDefaultsType: UserDefaultsSupportedType

    static func decode(userDefaultsValue value: UserDefaultsType) -> Self?
    var encodeForUserDefaults: UserDefaultsType? { get }
}

/** Automagically support optional values for convertibles
 */
extension Optional: UserDefaultsConvertible where Wrapped: UserDefaultsConvertible {

    public typealias UserDefaultsValueType = Wrapped
    public typealias UserDefaultsType = Wrapped.UserDefaultsType

    public static func decode(userDefaultsValue value: Wrapped.UserDefaultsType) -> Optional<Wrapped>? {
        return Wrapped.decode(userDefaultsValue: value)
    }

    public var encodeForUserDefaults: Wrapped.UserDefaultsType? {
        return wrappedValue?.encodeForUserDefaults
    }
}

// MARK: - internal types

struct UserDefaultsConvertibleBox<T: UserDefaultsConvertible>: UserDefaultsTransaction {

    let value: T

    var supportedType: Data? {
        return value.encodeForUserDefaults?.encode as Data?
    }

    init?(storedValue: Data?) {

        guard let storedValue: T.UserDefaultsType = storedValue?.decode(),
            let value = T.decode(userDefaultsValue: storedValue)
            else
        {
            return nil
        }

        self.value = value
    }

    init(_ value: T) {
        self.value = value
    }
}

struct UserDefaultsCodableBox<T: Codable>: UserDefaultsTransaction {

    let value: T

    var supportedType: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode([value])
    }

    init?(storedValue: Data?) {

        guard let storedValue = storedValue else {
            return nil
        }

        let processedData = _decodeLegacyType(T.self, data: storedValue)
            ?? storedValue

        let decoder = JSONDecoder()
        if let box = try? decoder.decode([T].self, from: processedData),
            let value = box.first {
            self.value = value
        } else {
            return nil
        }
    }

    init(_ value: T) {
        self.value = value
    }
}

/** LEGACY:
 For backward compatibility, we try to decode the data as NSCoding first since
 some codable types were stored with NSCoding in the past.
 */
private func _decodeLegacyType<T>(_ type: T.Type, data: Data) -> Data? {

    func wrap<C: Codable>(_ value: C) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode([value])
    }

    switch type {
    case is Int.Type, is Int?.Type:
        return (data.decode() as NSNumber?).flatMap { wrap($0.intValue) }
    case is Double.Type, is Double?.Type:
        return (data.decode() as NSNumber?).flatMap { wrap($0.doubleValue) }
    case is Float.Type, is Float?.Type:
        return (data.decode() as NSNumber?).flatMap { wrap($0.floatValue) }
    case is Bool.Type, is Bool?.Type:
        return (data.decode() as NSNumber?).flatMap { wrap($0.boolValue) }
    case is String.Type, is String?.Type:
        return (data.decode() as NSString?).flatMap { wrap($0 as String) }
    case is Date.Type, is Date?.Type:
        return (data.decode() as NSDate?).flatMap { wrap($0 as Date) }
    default:
        return nil
    }
}
