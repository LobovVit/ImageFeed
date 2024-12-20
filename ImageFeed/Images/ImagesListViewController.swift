//
//  ViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 27.09.2024.
//

import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController,ImagesListViewControllerProtocol {
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    var presenter: ImagesListViewPresenterProtocol?
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.addSubview(tableView)
        presenter = ImagesListViewPresenter(view: self)
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                super.prepare(for: segue, sender: sender)
                return
            }
            viewController.largeImageURL = URL(string: photos[indexPath.row].largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func updateTableViewAnimated() {
        DispatchQueue.main.async {
            let oldCount = self.photos.count
            let newCount = self.imageListService.photos.count
            self.tableView.performBatchUpdates({
                self.photos = self.imageListService.photos
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            })
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        if cell.loadCell(from: photos[indexPath.row]) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let thumbImageSize = photos[indexPath.row].thumbSize
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = thumbImageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = thumbImageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count && !ProcessInfo.processInfo.arguments.contains("testing"){
            imageListService.fetchPhotoNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self ] result in
            guard let self else { return }
            switch result {
            case .success(let isLiked):
                self.photos[indexPath.row].isLiked = isLiked
                cell.setIsLiked(isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
}
