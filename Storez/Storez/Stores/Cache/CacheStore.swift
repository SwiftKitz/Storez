//
//  CacheStore.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/8/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation


public final class CacheStore: Store {
        
    public let cache = NSCache()
    
    public init() {}
    
    public func clear() {
        cache.removeAllObjects()
    }
    
    private func _read<K: KeyType, B: CacheTransaction where K.ValueType == B.ValueType>(key: K, boxType: B.Type) -> K.ValueType {
        
        let object: AnyObject? = cache.objectForKey(key.stringValue)
        return  boxType.init(storedValue: object)?.value ?? key.defaultValue
    }
    
    private func _write<K: KeyType>(key: K, object: AnyObject?) {
        
        K.NamespaceType.preCommitHook()
        
        if let object = object {
            cache.setObject(object, forKey: key.stringValue)
        }
        else {
            cache.removeObjectForKey(key.stringValue)
        }
        
        K.NamespaceType.postCommitHook()
    }
    
    private func _set<K: KeyType, B: CacheTransaction where K.ValueType == B.ValueType>(key: K, box: B) {
        
        let oldValue = _read(key, boxType: B.self)
        let newValue = key.processChange(oldValue, newValue: box.value ?? key.defaultValue)
        let newBox = B(newValue)
        
        key.willChange(oldValue, newValue: newValue)
        _write(key, object: newBox.supportedType)
        key.didChange(oldValue, newValue: newValue)
    }
    
    public func get<K: KeyType where K.ValueType: CacheSupportedType>(key: K) -> K.ValueType {
        return _read(key, boxType: CacheSupportedBox.self)
    }
    
    public func get<K: KeyType, V: CacheSupportedType where K.ValueType == V?>(key: K) -> V? {
        return _read(key, boxType: CacheNullableSupportedBox.self)
    }
    
    public func get<K: KeyType where K.ValueType: CacheConvertible>(key: K) -> K.ValueType {
        return _read(key, boxType: CacheConvertibleBox.self)
    }
    
    public func get<K: KeyType, V: CacheConvertible where K.ValueType == V?>(key: K) -> V? {
        return _read(key, boxType: CacheNullableConvertibleBox.self)
    }
    
    public func set<K: KeyType where K.ValueType: CacheSupportedType>(key: K, value: K.ValueType) {
        _set(key, box: CacheSupportedBox(value))
    }
    
    public func set<K: KeyType, V: CacheSupportedType where K.ValueType == V?>(key: K, value: V?) {
        _set(key, box: CacheNullableSupportedBox(value))
    }
    
    public func set<K: KeyType where K.ValueType: CacheConvertible>(key: K, value: K.ValueType) {
        _set(key, box: CacheConvertibleBox(value))
    }
    
    public func set<K: KeyType, V: CacheConvertible where K.ValueType == V?>(key: K, value: V?) {
        _set(key, box: CacheNullableConvertibleBox(value))
    }
}
