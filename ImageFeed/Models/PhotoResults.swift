//
//  PhotoResults.swift
//  ImageFeed
//
//  Created by Anna on 14.03.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: URLsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls
    }
}

struct URLsResult: Decodable {
    let large: String
    let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case large = "full"
        case thumb
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}
