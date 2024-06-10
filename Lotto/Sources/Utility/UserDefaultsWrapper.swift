//
//  UserDefaultsWrapper.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

enum UserDefaultsKey: String {
    case recentlyRound
}

@propertyWrapper
struct UserDefaultsWrapper<T: Codable> {
    private let key: UserDefaultsKey
    private let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue)
            else { return defaultValue }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                Logger.error(error)
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: key.rawValue)
            } catch {
                Logger.error(error)
            }
        }
    }
    
    init(key: UserDefaultsKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
