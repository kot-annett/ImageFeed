//
//  UserResult.swift
//  ImageFeed
//
//  Created by Anna on 04.03.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
