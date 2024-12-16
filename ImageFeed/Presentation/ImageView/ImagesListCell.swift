//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 08.10.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let placeholderImage = UIImage(named: "placeholder")
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter
    }()
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likedImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likedImage, for: .normal)
    }
    
    func loadCell(from photo: Photo) -> Bool {
        var status = false
        
        if let photoDate = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: photoDate)
        } else {
            dateLabel.text = ""
        }
        
        setIsLiked(photo.isLiked)
        
        guard let photoURL = URL(string: photo.thumbImageURL) else { return status }
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoURL, placeholder: placeholderImage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                status = true
            case .failure(let error):
                cellImage.image = placeholderImage
                print("ERR: \(error.localizedDescription)")
            }
        }
        return status
    }
}
