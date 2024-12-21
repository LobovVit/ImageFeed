//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//

import Foundation

public protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func notificationObserver()
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        notificationObserver()
        ImageListService.shared.fetchPhotoNextPage()
    }
    
    func notificationObserver() {
        NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            view?.updateTableViewAnimated()
        }
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        ImageListService.shared.changeLike(photoId: photoId, isLike: isLiked) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(_):
                completion(.success(()))
            case.failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
