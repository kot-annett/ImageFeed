//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anna on 12.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "OAuth2AccessToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
