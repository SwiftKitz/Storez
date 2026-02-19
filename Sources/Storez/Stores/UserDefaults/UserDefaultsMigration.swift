//
//  UserDefaultsMigration.swift
//  Storez
//
//  Created by Storez contributors.
//

import Foundation

/// A type-erased migration entry that encapsulates migrating an old
/// plain UserDefaults key to a new typed Storez key.
///
/// Because `KeyType` has associated types, heterogeneous migrations
/// cannot be stored in a single array directly. `Migration` solves
/// this by capturing all generic work inside a closure at creation
/// time.
///
/// **Usage:**
/// ```swift
/// let migration = UserDefaultsStore.Migration(
///     to: Key<MyNamespace, City>(id: "city", defaultValue: .default),
///     from: "CityId"
/// ) { oldValue in
///     myDatabase.getCity(oldValue as! String)
/// }
///
/// store.migrate([migration])
/// ```
public extension UserDefaultsStore {

    struct Migration: Sendable {

        let perform: @Sendable (UserDefaults) -> Void

        /// Creates a migration that moves a plain UserDefaults value
        /// stored under `oldKey` to the new typed Storez key.
        ///
        /// - Parameters:
        ///   - key: The new typed key to migrate **to**.
        ///   - oldKey: The old raw UserDefaults key string to migrate **from**.
        ///   - processor: A closure that receives the old raw value (`Any`)
        ///     and returns the converted value for the new key.
        ///     Return `nil` to skip the migration for this entry.
        public init<K: KeyType>(
            to key: K,
            from oldKey: String,
            processor: @escaping @Sendable (Any) -> K.ValueType?
        ) where K.ValueType: UserDefaultsConvertible, K.ValueType: Sendable {
            let newKey = key.stringValue
            self.perform = { defaults in
                guard let oldValue = defaults.object(forKey: oldKey) else {
                    return
                }
                guard let newValue = processor(oldValue) else {
                    return
                }

                let box = UserDefaultsConvertibleBox(newValue)
                defaults.set(box.supportedType, forKey: newKey)
                defaults.removeObject(forKey: oldKey)
            }
        }

        /// Creates a migration for values conforming to `UserDefaultsSupportedType` (NSCoding).
        public init<K: KeyType>(
            to key: K,
            from oldKey: String,
            processor: @escaping @Sendable (Any) -> K.ValueType?
        ) where K.ValueType: UserDefaultsSupportedType, K.ValueType: Sendable {
            let newKey = key.stringValue
            self.perform = { defaults in
                guard let oldValue = defaults.object(forKey: oldKey) else {
                    return
                }
                guard let newValue = processor(oldValue) else {
                    return
                }

                let box = UserDefaultsSupportedTypeBox(newValue)
                defaults.set(box.supportedType, forKey: newKey)
                defaults.removeObject(forKey: oldKey)
            }
        }

        /// Creates a migration for values conforming to `Codable`.
        public init<K: KeyType>(
            to key: K,
            from oldKey: String,
            processor: @escaping @Sendable (Any) -> K.ValueType?
        ) where K.ValueType: Codable, K.ValueType: Sendable {
            let newKey = key.stringValue
            self.perform = { defaults in
                guard let oldValue = defaults.object(forKey: oldKey) else {
                    return
                }
                guard let newValue = processor(oldValue) else {
                    return
                }

                let box = UserDefaultsCodableBox(newValue)
                defaults.set(box.supportedType, forKey: newKey)
                defaults.removeObject(forKey: oldKey)
            }
        }
    }
}
