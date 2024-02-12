//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anna on 12.02.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession: URLSession
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
//    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        let request = authTokenRequest(code: code)
//        let task = object(for: request) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let body):
//                let authToken = body.accessToken
//                self.authToken = authToken
//                completion(.success(authToken))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
}
        
        
        
//        // first
//        let tokenURL = URL(string: "https://unsplash.com/oauth/token")!
//
//        let params: [String: String] = [
//            "client_id": accessKey,
//            "client_secret": secretKey,
//            "redirect_uri": redirectURI,
//            "code": code,
//            "grant_type": "authorization_code"
//        ]
//
//        var request = URLRequest(url: tokenURL)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//            DispatchQueue.main.async {
//                completion(.failure(error))
//            }
//            return
//        }
//
//        let task = urlSession.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                let error = NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//
//            guard (200...299).contains(httpResponse.statusCode) else {
//                let error = NSError(domain: "OAuth2Service", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP request failed"])
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//
//            guard let data = data else {
//                let error = NSError(domain: "OAuth2Service", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//                return
//            }
//
//            do {
//                let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(tokenResponse.accessToken))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//        task.resume()
//    }
//}

// second
//extension OAuth2Service {
//    private func object(
//        for request: URLRequest,
//        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return urlSession.data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
//                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
//            }
//            completion(response)
//        }
//    }
//    
//    private func authTokenRequest(code: String) -> URLRequest {
//        URLRequest.makeHTTPRequest(
//            path: "/oauth/token"
//            + "?client_id=\(accessKey)"
//            + "&&client_secret=\(secretKey)"
//            + "&&redirect_uri=\(redirectURI)"
//            + "&&code=\(code)"
//            + "&&grant_type=authorization_code",
//            httpMethod: "POST",
//            baseURL: URL(string: "https://unsplash.com")!
//        )
//    }
//}

