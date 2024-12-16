//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol?
    var tableViewUpdatesCalled: Bool =  false
    
    func updateTableViewAnimated() {
        tableViewUpdatesCalled = true
    }
}
