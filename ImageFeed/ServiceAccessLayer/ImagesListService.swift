//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anna on 14.03.2024.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private let urlSession: URLSession
    private var lastTask: URLSessionTask?
    
    init() {
        urlSession = URLSession.shared
    }
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard lastTask == nil else {
            print("Загрузка уже идет")
            return
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = imagesListRequest(token: token, page: nextPage) else {
            print("Ошибка формирования запроса")
            completion(.failure(NetworkError.badURL))
            return
        }
        lastTask = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map({Photo(photo: $0)})
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                self.lastTask = nil
                completion(.success(self.photos))
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos]
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        lastTask?.resume()
    }
    
    func imagesListRequest(token: String, page: Int) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)",
            httpMethod: "GET",
            baseURL: defaultBaseURL
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
