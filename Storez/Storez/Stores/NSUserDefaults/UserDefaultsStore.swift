//
//  UserDefaultsStore.swift
//  Storez
//
//  Created by Mazyad Alabduljaleel on 11/5/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


public final class UserDefaultsStore: Store {
    
    public typealias SerializableType = UserDefaultsSupportedType
    
    public let defaults: NSUserDefaults
    
    // MARK: - Init & Dealloc
    
    public init(suite: String?) {
        defaults = NSUserDefaults(suiteName: suite)!
    }
    
    // MARK: - Private methods
    
    private func _get<V: SerializableType>(key: String) -> V? {
        return defaults.objectForKey(key) as? V
    }
    
    private func _set<E: EntryType>(entry: E, value: SerializableType?) {
        
        defaults.setObject(value, forKey: entry.key)
        defaults.synchronize()
        
        E.GroupType.postCommitHook()
    }
    
    // MARK: - Public methods
    
    public func clear() {
        
        defaults.dictionaryRepresentation()
            .forEach { defaults.removeObjectForKey($0.0) }
        defaults.synchronize()
    }

    public func get<E: EntryType where E.ValueType: SerializableType>(entry: E) -> E.ValueType {
        return _get(entry.key) ?? entry.defaultValue
    }
    
    public func get<E: EntryType, V: SerializableType where E.ValueType == V?>(entry: E) -> V? {
        return _get(entry.key) ?? entry.defaultValue
    }

    private func _get<V: UserDefaultsConvertible>(key: String) -> V? {
        
        if let serializedValue: V.UserDefaultsType = _get(key) {
            return V.decode(userDefaultsValue: serializedValue)
        }
        
        return nil
    }
    
    public func get<E: EntryType where E.ValueType: UserDefaultsConvertible>(entry: E) -> E.ValueType {
        
        let resultValue: E.ValueType? = _get(entry.key)
        return resultValue ?? entry.defaultValue
    }
    
    public func get<E: EntryType, V: UserDefaultsConvertible where E.ValueType == V?>(entry: E) -> V? {
        
        let resultValue: V? = _get(entry.key)
        return resultValue ?? entry.defaultValue
    }
    
    public func get<E: EntryType where E.ValueType: NSCoding>(entry: E) -> E.ValueType {
        
        let data: NSData? = _get(entry.key)
        return data?.decode() ?? entry.defaultValue
    }
    
    public func get<E: EntryType, V: NSCoding where E.ValueType == V?>(entry: E) -> V? {

        let data: NSData? = _get(entry.key)
        return data?.decode() ?? entry.defaultValue
    }
    
    public func set<E: EntryType where E.ValueType: SerializableType>(entry: E, value: E.ValueType) {
        
        let newValue = entry.willChange(value)
        _set(entry, value: newValue)
    }
    
    public func set<E: EntryType, V: SerializableType where E.ValueType == V?>(entry: E, value: V?) {
        
        let newValue = entry.willChange(value)
        _set(entry, value: newValue)
    }
    
    public func set<E: EntryType where E.ValueType: UserDefaultsConvertible>(entry: E, value: E.ValueType) {
        
        let newValue = entry.willChange(value)
        _set(entry, value: newValue.encodeForUserDefaults)
    }
    
    public func set<E: EntryType, V: UserDefaultsConvertible where E.ValueType == V?>(entry: E, value: V?) {
        
        let newValue = entry.willChange(value)
        _set(entry, value: newValue?.encodeForUserDefaults)
    }
    
    public func set<E: EntryType where E.ValueType: NSCoding>(entry: E, value: E.ValueType) {
        
        let newValue = entry.willChange(value)
        _set(entry, value: newValue.encode)
    }
    
    public func set<E: EntryType, V: NSCoding where E.ValueType == V?>(entry: E, value: V?) {
        
        let newValue = entry.willChange(value)
        _set(entry, value: newValue?.encode)
    }
}
