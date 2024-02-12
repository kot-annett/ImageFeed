//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anna on 12.02.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "OAuth2AccessToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
