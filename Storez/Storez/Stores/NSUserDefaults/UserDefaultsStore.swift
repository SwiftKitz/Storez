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
    typealias SupportedType: UserDefaultsSupportedType
    
    var supportedType: UserDefaultsSupportedType? { get }
    var value: ValueType? { get }
    
    init(storedValue: SupportedType?)
    init(_ value: ValueType?)
}

public final class UserDefaultsStore: Store {
    
    public let defaults: NSUserDefaults
    
    // MARK: - Init & Dealloc
    
    public init(suite: String?) {
        defaults = NSUserDefaults(suiteName: suite)!
    }
    
    // MARK: - Private methods
    
    private func _read<E: EntryType, B: UserDefaultsAcceptedType>(entry: E) -> B? {
        
        let data = defaults.objectForKey(entry.key) as? NSData
        return B(storedValue: data?.decode())
    }
    
    private func _write<E: EntryType>(entry: E, value: UserDefaultsSupportedType?) {
        
        E.GroupType.preCommitHook()
        
        defaults.setObject(value?.encode, forKey: entry.key)
        defaults.synchronize()
        
        E.GroupType.postCommitHook()
    }
    
    private func _set<E: EntryType, B: UserDefaultsAcceptedType where E.ValueType == B.ValueType>(entry: E, box: B) {
        
        let oldBox: B? = _read(entry)
        let oldValue = oldBox?.value ?? entry.defaultValue
        let newValue = entry.processChange(oldValue, newValue: box.value ?? entry.defaultValue)
        let newBox = B(newValue)
        
        entry.willChange(oldValue, newValue: newValue)
        _write(entry, value: newBox.supportedType)
        entry.didChange(oldValue, newValue: newValue)
    }
    
    private func _set<E: EntryType, B: UserDefaultsAcceptedType, V where E.ValueType == V?, V == B.ValueType>(entry: E, box: B) {
        
        let oldBox: B? = _read(entry)
        let oldValue = oldBox?.value ?? entry.defaultValue
        let newValue = entry.processChange(oldValue, newValue: box.value ?? entry.defaultValue)
        let newBox = B(newValue)
        
        entry.willChange(oldValue, newValue: newValue)
        _write(entry, value: newBox.supportedType)
        entry.didChange(oldValue, newValue: newValue)
    }
    
    // MARK: - Public methods
    
    public func clear() {
        
        defaults.dictionaryRepresentation()
            .forEach { defaults.removeObjectForKey($0.0) }
        defaults.synchronize()
    }

    public func get<E: EntryType where E.ValueType: UserDefaultsConvertible>(entry: E) -> E.ValueType {
        
        let box: UserDefaultsConvertibleBox<E.ValueType>? = _read(entry)
        return box?.value ?? entry.defaultValue
    }
    
    public func get<E: EntryType, V: UserDefaultsConvertible where E.ValueType == V?>(entry: E) -> V? {
        
        let box: UserDefaultsConvertibleBox<V>? = _read(entry)
        return box?.value ?? entry.defaultValue
    }
    
    public func get<E: EntryType where E.ValueType: UserDefaultsSupportedType>(entry: E) -> E.ValueType {
        
        let box: UserDefaultsSupportedTypeBox<E.ValueType>? = _read(entry)
        return box?.value ?? entry.defaultValue
    }
    
    public func get<E: EntryType, V: NSCoding where E.ValueType == V?>(entry: E) -> V? {

        let box: UserDefaultsSupportedTypeBox<V>? = _read(entry)
        return box?.value ?? entry.defaultValue
    }
    
    public func set<E: EntryType where E.ValueType: UserDefaultsConvertible>(entry: E, value: E.ValueType) {
        _set(entry, box: UserDefaultsConvertibleBox(value))
    }
    
    public func set<E: EntryType, V: UserDefaultsConvertible where E.ValueType == V?>(entry: E, value: V?) {
        _set(entry, box: UserDefaultsConvertibleBox(value))
    }
    
    public func set<E: EntryType where E.ValueType: NSCoding>(entry: E, value: E.ValueType) {
        _set(entry, box: UserDefaultsSupportedTypeBox(value))
    }
    
    public func set<E: EntryType, V: NSCoding where E.ValueType == V?>(entry: E, value: V?) {
        _set(entry, box: UserDefaultsSupportedTypeBox(value))
    }
}


