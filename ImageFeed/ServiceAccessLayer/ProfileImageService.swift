//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Anna on 23.02.2024.
//

import Foundation
import UIKit

final class ProfileImageService {
    
    struct UserResult: Codable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }

    struct ProfileImage: Codable {
        let small: String?
    }
    
    static let shared = ProfileImageService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        NotificationCenter.default
            .post(
                name: ProfileImageService.didChangeNotification,
                object: self,
                userInfo: ["URL": avatarURL as Any])
        
        guard let token = oauth2TokenStorage.token else {
            let error = NetworkError.invalidAccessToken
            print("[fetchProfileImageURL]: \(error)")
            completion(.failure(error))
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            let error = NetworkError.badURL
            print("[fetchProfileImageURL]: \(error) - username: \(username), token: \(token)")
            completion(.failure(error))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileImage, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileImage):
                self.avatarURL = profileImage.small
                completion(.success(self.avatarURL ?? ""))
            case .failure(let error):
                print("[fetchProfileImageURL]: \(error)")
                completion(.failure(error))
            }
        }
       
        task?.resume()
    }
    
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

