//
//  CacheStore.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 12/8/15.
//  Copyright © 2015 mazy. All rights reserved.
//

import Foundation


public final class CacheStore: Store, @unchecked Sendable {
        
    public let cache = NSCache<AnyObject, AnyObject>()
    
    public init() {}
    
    public func clear() {
        cache.removeAllObjects()
    }
    
    fileprivate func _read<K: KeyType, B: CacheTransaction>(_ key: K, boxType: B.Type) -> K.ValueType where K.ValueType == B.ValueType {
        
        let object: AnyObject? = cache.object(forKey: key.stringValue as AnyObject)
        return  boxType.init(storedValue: object)?.value ?? key.defaultValue
    }
    
    fileprivate func _write<K: KeyType>(_ key: K, object: AnyObject?) {
        
        K.NamespaceType.preCommitHook()
        
        if let object = object {
            cache.setObject(object, forKey: key.stringValue as AnyObject)
        }
        else {
            cache.removeObject(forKey: key.stringValue as AnyObject)
        }
        
        K.NamespaceType.postCommitHook()
    }
    
    fileprivate func _set<K: KeyType, B: CacheTransaction>(_ key: K, box: B) where K.ValueType == B.ValueType {
        
        let oldValue = _read(key, boxType: B.self)
        let newValue = key.processChange(oldValue, newValue: box.value)
        let newBox = B(newValue)
        
        key.willChange(oldValue, newValue: newValue)
        _write(key, object: newBox.supportedType)
        key.didChange(oldValue, newValue: newValue)
    }
    
    public func get<K: KeyType>(_ key: K) -> K.ValueType where K.ValueType: CacheSupportedType {
        return _read(key, boxType: CacheSupportedBox.self)
    }
    
    public func get<K: KeyType, V: CacheSupportedType>(_ key: K) -> V? where K.ValueType == V? {
        return _read(key, boxType: CacheNullableSupportedBox.self)
    }
    
    public func get<K: KeyType>(_ key: K) -> K.ValueType where K.ValueType: CacheConvertible {
        return _read(key, boxType: CacheConvertibleBox.self)
    }
    
    public func get<K: KeyType, V: CacheConvertible>(_ key: K) -> V? where K.ValueType == V? {
        return _read(key, boxType: CacheNullableConvertibleBox.self)
    }
    
    public func set<K: KeyType>(_ key: K, value: K.ValueType) where K.ValueType: CacheSupportedType {
        _set(key, box: CacheSupportedBox(value))
    }
    
    public func set<K: KeyType, V: CacheSupportedType>(_ key: K, value: V?) where K.ValueType == V? {
        _set(key, box: CacheNullableSupportedBox(value))
    }
    
    public func set<K: KeyType>(_ key: K, value: K.ValueType) where K.ValueType: CacheConvertible {
        _set(key, box: CacheConvertibleBox(value))
    }
    
    public func set<K: KeyType, V: CacheConvertible>(_ key: K, value: V?) where K.ValueType == V? {
        _set(key, box: CacheNullableConvertibleBox(value))
    }
}
