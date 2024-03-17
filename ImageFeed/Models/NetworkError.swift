//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Anna on 04.03.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case httpStatusCode(Int)
    case badWebKitResponse
    case urlRequestError(Error)
    case urlSessionError
    case invalidAccessToken
}
