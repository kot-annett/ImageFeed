//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Anna on 22.02.2024.
//

import Foundation

final class ProfileService {
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio = "bio"
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String?

        init(username: String, firstName: String, lastName: String, bio: String?) {
            self.username = username
            self.name = "\(firstName) \(lastName)"
            self.loginName = "@\(username)"
            self.bio = bio
        }
    }
    
    static let shared = ProfileService()
    var profile: Profile?
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionDataTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileRequest(token: token) else {
            let error = NetworkError.badURL
            print("[fetchProfile]: \(error) - token: \(token)")
            completion(.failure(error))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(
                    username: profileResult.username,
                    firstName: profileResult.firstName,
                    lastName: profileResult.lastName,
                    bio: profileResult.bio
                )
                completion(.success(profile))
            case .failure(let error):
                print("[fetchProfile]: \(error)")
                completion(.failure(error))
            }
            
            self.task = nil
        } as? URLSessionDataTask
        
        task?.resume()
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}



//        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(NetworkError.badWebKitResponse))
//                return
//            }
//
//            if httpResponse.statusCode == 401 {
//                completion(.failure(NetworkError.invalidAccessToken))
//                return
//            }
//
//            guard 200..<300 ~= httpResponse.statusCode else {
//                completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
//                return
//            }
//
//            do {
//                guard let data = data else {
//                    completion(.failure(NetworkError.urlSessionError))
//                    return
//                }
//
//                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
//                let profile = Profile(
//                    username: profileResult.username,
//                    firstName: profileResult.firstName,
//                    lastName: profileResult.lastName,
//                    bio: profileResult.bio
//                )
//                completion(.success(profile))
//            } catch {
//                completion(.failure(error))
//            }
//        }
