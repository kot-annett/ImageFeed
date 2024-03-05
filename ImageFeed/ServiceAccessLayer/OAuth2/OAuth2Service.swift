//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anna on 12.02.2024.
//

import Foundation

fileprivate let tokenURL = URL(string: "https://unsplash.com/oauth/token")!

final class OAuth2Service {
    private static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        do {
            let request = try authTokenRequest(code: code)
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let body):
                        let authToken = body.accessToken
                        self.authToken = authToken
                        completion(.success(authToken))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    self.task = nil
                    self.lastCode = nil
                }
            }
            self.task = task
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    static func logError(_ error: Error, request: URLRequest) {
        print("[OAuth2Service]: Error - \(error.localizedDescription). Request - \(request)")
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let task = urlSession.dataTask(with: request) { data, response, error  in
            if let error = error {
                OAuth2Service.logError(error, request: request)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NetworkError.urlSessionError
                OAuth2Service.logError(error, request: request)
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                completion(.success(decodedObject))
            } catch {
                OAuth2Service.logError(error, request: request)
                completion(.failure(error))
            }
        }
        task.resume()
        return task
    }
    
    private func authTokenRequest(code: String) throws -> URLRequest {
        
       guard let request = URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")
       ) else {
           throw NetworkError.badURL
       }
        return request
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL? = defaultBaseURL
    ) -> URLRequest? {
        guard let baseURL = baseURL else { return nil }
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
            let task = dataTask(with: request) { data, response, error in
                if let error = error {
                    print("[objectTask]: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NetworkError.urlSessionError
                    print("[objectTask]: \(error)")
                    completion(.failure(error))
                    return
                }
                
                do {
                    let decodeObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodeObject))
                } catch {
                    let dataString = String(data: data, encoding: .utf8) ?? ""
                    print("[objectTask]: Error decoding - \(error.localizedDescription). Data: \(dataString)")
                    completion(.failure(error))
                }
            }
            task.resume()
            return task
        }
}

