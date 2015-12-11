//
//  CacheStore.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/8/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation


public final class CacheStore: Store {
    
    public typealias SerializableType = CacheSupportedType
    
    public let cache = NSCache()
    
    public init() {}
    
    public func clear() {
        cache.removeAllObjects()
    }
    
    private func _get<V: SerializableType>(key: String) -> V? {
        return cache.objectForKey(key) as? V
    }
    
    private func _set<E: KeyType>(key: E, value: SerializableType?) {
        
        if let value = value {
            cache.setObject(value, forKey: key.stringValue)
        }
        else {
            cache.removeObjectForKey(key.stringValue)
        }
        
        E.GroupType.postCommitHook()
    }
    
    public func get<E: KeyType where E.ValueType: SerializableType>(key: E) -> E.ValueType {
        return _get(key.stringValue) ?? key.defaultValue
    }
    
    public func get<E: KeyType, V: SerializableType where E.ValueType == V?>(key: E) -> V? {
        return _get(key.stringValue) ?? key.defaultValue
    }
    
    private func _get<V: CacheConvertible>(key: String) -> V? {
        
        if let storedValue: V.CacheType = _get(key) {
            return V.decode(cacheValue: storedValue)
        }
        
        return nil
    }
    
    public func get<E: KeyType where E.ValueType: CacheConvertible>(key: E) -> E.ValueType {
        return _get(key.stringValue) ?? key.defaultValue
    }
    
    public func get<E: KeyType, V: CacheConvertible where E.ValueType == V?>(key: E) -> V? {
        return _get(key.stringValue) ?? key.defaultValue
    }
    
    public func set<E: KeyType where E.ValueType: SerializableType>(key: E, value: E.ValueType) {
        _set(key, value: value)
    }
    
    public func set<E: KeyType, V: SerializableType where E.ValueType == V?>(key: E, value: V?) {
        _set(key, value: value)
    }
    
    public func set<E: KeyType where E.ValueType: CacheConvertible>(key: E, value: E.ValueType) {
        _set(key, value: value.encodeForCache)
    }
    
    public func set<E: KeyType, V: CacheConvertible where E.ValueType == V?>(key: E, value: V?) {
        _set(key, value: value?.encodeForCache)
    }
}
