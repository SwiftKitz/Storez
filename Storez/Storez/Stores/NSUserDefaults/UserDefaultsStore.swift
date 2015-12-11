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
    
    private func _read<E: KeyType, B: UserDefaultsAcceptedType where E.ValueType == B.ValueType>(entry: E, boxType: B.Type) -> E.ValueType {
        
        let data = defaults.objectForKey(entry.key) as? NSData
        return boxType.init(storedValue: data)?.value ?? entry.defaultValue
    }
    
    private func _write<E: KeyType>(entry: E, data: NSData?) {
        
        E.GroupType.preCommitHook()
        
        defaults.setObject(data, forKey: entry.key)
        defaults.synchronize()
        
        E.GroupType.postCommitHook()
    }
    
    private func _set<E: KeyType, B: UserDefaultsAcceptedType where E.ValueType == B.ValueType>(entry: E, box: B) {
        
        let oldValue = _read(entry, boxType: B.self)
        let newValue = entry.processChange(oldValue, newValue: box.value ?? entry.defaultValue)
        let newBox = B(newValue)
        
        entry.willChange(oldValue, newValue: newValue)
        _write(entry, data: newBox.supportedType)
        entry.didChange(oldValue, newValue: newValue)
    }
    
    // MARK: - Public methods
    
    public func clear() {
        
        defaults.dictionaryRepresentation()
            .forEach { defaults.removeObjectForKey($0.0) }
        defaults.synchronize()
    }

    public func get<E: KeyType where E.ValueType: UserDefaultsConvertible>(entry: E) -> E.ValueType {
        return _read(entry, boxType: UserDefaultsConvertibleBox.self)
    }
    
    public func get<E: KeyType, V: UserDefaultsConvertible where E.ValueType == V?>(entry: E) -> V? {
        return _read(entry, boxType: UserDefaultsNullableConvertibleBox.self)
    }
    
    public func get<E: KeyType where E.ValueType: UserDefaultsSupportedType>(entry: E) -> E.ValueType {
        return _read(entry, boxType: UserDefaultsSupportedTypeBox.self)
    }
    
    public func get<E: KeyType, V: NSCoding where E.ValueType == V?>(entry: E) -> V? {
        return _read(entry, boxType: UserDefaultsNullableSupportedTypeBox.self)
    }
    
    public func set<E: KeyType where E.ValueType: UserDefaultsConvertible>(entry: E, value: E.ValueType) {
        _set(entry, box: UserDefaultsConvertibleBox(value))
    }
    
    public func set<E: KeyType, V: UserDefaultsConvertible where E.ValueType == V?>(entry: E, value: V?) {
        _set(entry, box: UserDefaultsNullableConvertibleBox(value))
    }
    
    public func set<E: KeyType where E.ValueType: NSCoding>(entry: E, value: E.ValueType) {
        _set(entry, box: UserDefaultsSupportedTypeBox(value))
    }
    
    public func set<E: KeyType, V: NSCoding where E.ValueType == V?>(entry: E, value: V?) {
        _set(entry, box: UserDefaultsNullableSupportedTypeBox(value))
    }
}


