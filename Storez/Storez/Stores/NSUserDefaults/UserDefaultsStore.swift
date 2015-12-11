//
//  UserDefaultsStore.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


protocol UserDefaultsAcceptedType {
    
    typealias ValueType
    
    var supportedType: NSData? { get }
    var value: ValueType { get }
    
    init?(storedValue: NSData?)
    init(_ value: ValueType)
}

public final class UserDefaultsStore: Store {
    
    public let defaults: NSUserDefaults
    
    // MARK: - Init & Dealloc
    
    public init(suite: String?) {
        defaults = NSUserDefaults(suiteName: suite)!
    }
    
    // MARK: - Private methods
    
    private func _read<E: KeyType, B: UserDefaultsAcceptedType where E.ValueType == B.ValueType>(key: E, boxType: B.Type) -> E.ValueType {
        
        let data = defaults.objectForKey(key.stringValue) as? NSData
        return boxType.init(storedValue: data)?.value ?? key.defaultValue
    }
    
    private func _write<E: KeyType>(key: E, data: NSData?) {
        
        E.GroupType.preCommitHook()
        
        defaults.setObject(data, forKey: key.stringValue)
        defaults.synchronize()
        
        E.GroupType.postCommitHook()
    }
    
    private func _set<E: KeyType, B: UserDefaultsAcceptedType where E.ValueType == B.ValueType>(key: E, box: B) {
        
        let oldValue = _read(key, boxType: B.self)
        let newValue = key.processChange(oldValue, newValue: box.value ?? key.defaultValue)
        let newBox = B(newValue)
        
        key.willChange(oldValue, newValue: newValue)
        _write(key, data: newBox.supportedType)
        key.didChange(oldValue, newValue: newValue)
    }
    
    // MARK: - Public methods
    
    public func clear() {
        
        defaults.dictionaryRepresentation()
            .forEach { defaults.removeObjectForKey($0.0) }
        defaults.synchronize()
    }

    public func get<E: KeyType where E.ValueType: UserDefaultsConvertible>(key: E) -> E.ValueType {
        return _read(key, boxType: UserDefaultsConvertibleBox.self)
    }
    
    public func get<E: KeyType, V: UserDefaultsConvertible where E.ValueType == V?>(key: E) -> V? {
        return _read(key, boxType: UserDefaultsNullableConvertibleBox.self)
    }
    
    public func get<E: KeyType where E.ValueType: UserDefaultsSupportedType>(key: E) -> E.ValueType {
        return _read(key, boxType: UserDefaultsSupportedTypeBox.self)
    }
    
    public func get<E: KeyType, V: NSCoding where E.ValueType == V?>(key: E) -> V? {
        return _read(key, boxType: UserDefaultsNullableSupportedTypeBox.self)
    }
    
    public func set<E: KeyType where E.ValueType: UserDefaultsConvertible>(key: E, value: E.ValueType) {
        _set(key, box: UserDefaultsConvertibleBox(value))
    }
    
    public func set<E: KeyType, V: UserDefaultsConvertible where E.ValueType == V?>(key: E, value: V?) {
        _set(key, box: UserDefaultsNullableConvertibleBox(value))
    }
    
    public func set<E: KeyType where E.ValueType: NSCoding>(key: E, value: E.ValueType) {
        _set(key, box: UserDefaultsSupportedTypeBox(value))
    }
    
    public func set<E: KeyType, V: NSCoding where E.ValueType == V?>(key: E, value: V?) {
        _set(key, box: UserDefaultsNullableSupportedTypeBox(value))
    }
}


