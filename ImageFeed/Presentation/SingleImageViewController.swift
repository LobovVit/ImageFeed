//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 17.10.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
            didSet {
                guard isViewLoaded else { return } // 1
                imageView.image = image // 2
            }
        }
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
