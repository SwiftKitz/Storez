//
//  UserDefaultsStore.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


public final class UserDefaultsStore: Store {

    // MARK: - Properties
    
    public let defaults: UserDefaults
    
    // MARK: - Init & Dealloc
    
    public init(suite: String?) {
        defaults = UserDefaults(suiteName: suite)!
    }
    
    // MARK: - Private methods
    
    private func _read<K: KeyType, B: UserDefaultsTransaction>(_ key: K, boxType: B.Type)
        -> K.ValueType where K.ValueType == B.ValueType {
        
        let data = defaults.object(forKey: key.stringValue) as? Data
        return boxType.init(storedValue: data)?.value ?? key.defaultValue
    }
    
    private func _write<K: KeyType>(_ key: K, data: Data?) {
        
        K.NamespaceType.preCommitHook()
        
        defaults.set(data, forKey: key.stringValue)
        defaults.synchronize()
        
        K.NamespaceType.postCommitHook()
    }
    
    private func _set<K: KeyType, B: UserDefaultsTransaction>(_ key: K, box: B)
        where K.ValueType == B.ValueType {
        
        let oldValue = _read(key, boxType: B.self)
        let newValue = key.processChange(oldValue, newValue: box.value)
        let newBox = B(newValue)
        
        key.willChange(oldValue, newValue: newValue)
        _write(key, data: newBox.supportedType)
        key.didChange(oldValue, newValue: newValue)
    }
    
    // MARK: - Public methods
    
    public func clear() {
        
        defaults.dictionaryRepresentation()
            .forEach { defaults.removeObject(forKey: $0.0) }
        defaults.synchronize()
    }

    public func get<K: KeyType>(_ key: K) -> K.ValueType where K.ValueType: UserDefaultsConvertible {
        return _read(key, boxType: UserDefaultsConvertibleBox.self)
    }

    public func get<K: KeyType>(_ key: K) -> K.ValueType where K.ValueType: UserDefaultsSupportedType {
        return _read(key, boxType: UserDefaultsSupportedTypeBox.self)
    }
    
    public func get<K: KeyType, V: UserDefaultsSupportedType>(_ key: K) -> V? where K.ValueType == V? {
        return _read(key, boxType: UserDefaultsNullableSupportedTypeBox.self)
    }

    public func get<K: KeyType>(_ key: K) -> K.ValueType where K.ValueType: Codable {
        return _read(key, boxType: UserDefaultsCodableBox.self)
    }

    public func set<K: KeyType>(_ key: K, value: K.ValueType) where K.ValueType: UserDefaultsConvertible {
        _set(key, box: UserDefaultsConvertibleBox(value))
    }

    public func set<K: KeyType>(_ key: K, value: K.ValueType) where K.ValueType: UserDefaultsSupportedType {
        _set(key, box: UserDefaultsSupportedTypeBox(value))
    }
    
    public func set<K: KeyType, V: UserDefaultsSupportedType>(_ key: K, value: V?) where K.ValueType == V? {
        _set(key, box: UserDefaultsNullableSupportedTypeBox(value))
    }

    public func set<K: KeyType>(_ key: K, value: K.ValueType) where K.ValueType: Codable {
        _set(key, box: UserDefaultsCodableBox(value))
    }
}


