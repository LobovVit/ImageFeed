//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 06.12.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
    var secondButtonText: String?
    var secondCompletion: (() -> Void)? = {}
}

