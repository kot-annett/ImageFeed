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
            let task = object(for: request) { [weak self] result in
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
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
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
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}

enum NetworkError: Error {
    case badURL
    case httpStatusCode(Int)
    case badWebKitResponse
    case urlRequestError(Error)
    case urlSessionError
    case invalidAccessToken
}


//    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        do {
//            let request = try authTokenRequest(code: code)
//            let task = object(for: request) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let body):
//                    let authToken = body.accessToken
//                    self.authToken = authToken
//                    completion(.success(authToken))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        } catch {
//            completion(.failure(error))
//        }
//    }
//}



//    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        assert(Thread.isMainThread)
//        if lastCode == code { return }
//        task?.cancel()
//        lastCode = code
//
//        let request = makeRequest(code: code)
//        let task = urlSession.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                    self.task = nil
//                    self.lastCode = nil
//                    return
//                }
//                guard let data = data else {
//                    completion(.failure(NetworkError.urlSessionError))
//                    self.task = nil
//                    self.lastCode = nil
//                    return
//                }
//                do {
//                    let body = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
//                    let authToken = body.accessToken
//                    self.authToken = authToken
//                    completion(.success(authToken))
//                } catch {
//                    completion(.failure(error))
//                }
//                self.task = nil
//                self.lastCode = nil
//            }
//        }
//        self.task = task
//        task.resume()
//    }
//
//    private func makeRequest(code: String) -> URLRequest {
//        guard let url = URL(string: "...\(code)") else { fatalError("Failed to create URL")}
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        return request
//    }
//}

