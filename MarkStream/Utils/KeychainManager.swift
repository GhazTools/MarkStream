//
//  KeychainManager.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/1/24.
//

import Foundation
import KeychainSwift

struct KeychainKeys {
    static let username = "username"
    static let password = "password"
}

class KeychainManager {
    static let shared = KeychainManager() // SINGLETON INSTANCE
    private let keychain = KeychainSwift()

    private init() {} // Private initialization to ensure singleton instance

    func save(_ value: String, forKey key: String) {
        keychain.set(value, forKey: key)
    }

    func value(forKey key: String) -> String? {
        return keychain.get(key)
    }
}
