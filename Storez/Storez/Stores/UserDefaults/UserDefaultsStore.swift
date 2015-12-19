//
//  UserDefaultsStore.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


public final class UserDefaultsStore: Store {
    
    public let defaults: NSUserDefaults
    
    // MARK: - Init & Dealloc
    
    public init(suite: String?) {
        defaults = NSUserDefaults(suiteName: suite)!
    }
    
    // MARK: - Private methods
    
    private func _read<K: KeyType, B: UserDefaultsTransaction where K.ValueType == B.ValueType>(key: K, boxType: B.Type) -> K.ValueType {
        
        let data = defaults.objectForKey(key.stringValue) as? NSData
        return boxType.init(storedValue: data)?.value ?? key.defaultValue
    }
    
    private func _write<K: KeyType>(key: K, data: NSData?) {
        
        K.NamespaceType.preCommitHook()
        
        defaults.setObject(data, forKey: key.stringValue)
        defaults.synchronize()
        
        K.NamespaceType.postCommitHook()
    }
    
    private func _set<K: KeyType, B: UserDefaultsTransaction where K.ValueType == B.ValueType>(key: K, box: B) {
        
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

    public func get<K: KeyType where K.ValueType: UserDefaultsConvertible>(key: K) -> K.ValueType {
        return _read(key, boxType: UserDefaultsConvertibleBox.self)
    }
    
    public func get<K: KeyType, V: UserDefaultsConvertible where K.ValueType == V?>(key: K) -> V? {
        return _read(key, boxType: UserDefaultsNullableConvertibleBox.self)
    }
    
    public func get<K: KeyType where K.ValueType: UserDefaultsSupportedType>(key: K) -> K.ValueType {
        return _read(key, boxType: UserDefaultsSupportedTypeBox.self)
    }
    
    public func get<K: KeyType, V: NSCoding where K.ValueType == V?>(key: K) -> V? {
        return _read(key, boxType: UserDefaultsNullableSupportedTypeBox.self)
    }
    
    public func set<K: KeyType where K.ValueType: UserDefaultsConvertible>(key: K, value: K.ValueType) {
        _set(key, box: UserDefaultsConvertibleBox(value))
    }
    
    public func set<K: KeyType, V: UserDefaultsConvertible where K.ValueType == V?>(key: K, value: V?) {
        _set(key, box: UserDefaultsNullableConvertibleBox(value))
    }
    
    public func set<K: KeyType where K.ValueType: NSCoding>(key: K, value: K.ValueType) {
        _set(key, box: UserDefaultsSupportedTypeBox(value))
    }
    
    public func set<K: KeyType, V: NSCoding where K.ValueType == V?>(key: K, value: V?) {
        _set(key, box: UserDefaultsNullableSupportedTypeBox(value))
    }
}


