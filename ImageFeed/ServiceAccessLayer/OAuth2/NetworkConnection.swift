//
//  NetworkConnection.swift
//  ImageFeed
//
//  Created by Anna on 12.02.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case httpStatusCode(Int)
    case invalidDecoding
    case badWebKitResponse
//    case urlRequestError(Error)
//    case urlSessionError
}

//extension URLSession {
//    func data(
//        for request: URLRequest,
//        completion: @escaping (Result<Data, Error>) -> Void
//    ) -> URLSessionTask {
//        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        
//        let task = dataTask(with: request) { data, response, error in
//            if let data = data,
//               let response = response,
//               let statusCode = (response as? HTTPURLResponse)?.statusCode
//            {
//                if 200..<300 ~= statusCode {
//                    fulfillCompletion(.success(data))
//                } else {
//                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
//                }
//            } else if let error = error {
//                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
//            } else {
//                fulfillCompletion(.failure(NetworkError.urlSessionError))
//            }
//        }
//        task.resume()
//        return task
//    }
//}
//
