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
    private var authTokenStorage = OAuth2TokenStorage()
    
    init() {
        urlSession = URLSession.shared
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard lastTask == nil else {
            print("Загрузка уже идет")
            return
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = imagesListRequest(page: nextPage) else {
            print("Ошибка формирования запроса")
            return
        }
        lastTask = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photoResults):
                    let newPhotos = photoResults.map({Photo(photo: $0)})
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Photos": self.photos]
                        )}
                case .failure(let error):
                    print("Failed to fetch photos \(error)")
                }
                self.lastTask = nil
            }
        }
        lastTask?.resume()
    }
    
    func imagesListRequest(page: Int) -> URLRequest? {
        guard let token = authTokenStorage.token else {
            return nil
        }
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)",
            httpMethod: "GET",
            baseURL: defaultBaseURL
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func dateFormatter() -> DateFormatter {
        let date = DateFormatter()
        date.dateStyle = .long
        date.timeStyle = .none
        return date
    }
}
