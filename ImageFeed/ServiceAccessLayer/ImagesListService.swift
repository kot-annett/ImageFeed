//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anna on 14.03.2024.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private let urlSession: URLSession
    private var lastTask: URLSessionTask?
    private var authTokenStorage = OAuth2TokenStorage.shared
    
    private init() {
        urlSession = URLSession.shared
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard lastTask == nil else {
            print("Loading in progress")
            return
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = imagesListRequest(page: nextPage) else {
            print("Error forming request")
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

    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void) {
            assert(Thread.isMainThread)
            
            guard let request = makeLikeRequest(id: photoId, isLike: isLike) else {
                assertionFailure("Invalid request")
                return
            }
            lastTask = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let photoResult):
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            let photo = self.photos[index]
                            let newPhoto = Photo(
                                id: photo.id,
                                size: photo.size,
                                createdAt: photo.createdAt,
                                welcomeDescription: photo.welcomeDescription,
                                largeImageURL: photo.largeImageURL,
                                thumbImageURL: photo.thumbImageURL,
                                isLiked: !photo.isLiked
                            )
                            self.photos[index] = newPhoto
                        }
                        completion(.success(()))
                    case .failure(let error):
                        print("Failed to change like status: \(error)")
                    }
                    self.lastTask = nil
                }
            }
            lastTask?.resume()
        }
    
    func clearPhotos() {
        photos = []
    }
    
    private func makeLikeRequest(id: String, isLike: Bool) -> URLRequest? {
        guard let token = authTokenStorage.token else {
            return nil
        }
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: isLike ? "POST" : "DELETE",
            baseURL: defaultBaseURL
        )
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
}
   
