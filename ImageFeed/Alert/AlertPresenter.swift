//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//
import UIKit

protocol AlertPresenting: AnyObject {
    func showAlert(for result: AlertModel)
}

final class AlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

extension AlertPresenter: AlertPresenting {
    
    func showAlert(for result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
        }
        alert.addAction(alertAction)
        
        if let secondButtonText = result.secondButtonText {
            let secondAction = UIAlertAction(title: secondButtonText, style: .default) { _ in
                result.secondCompletion?()
            }
            alert.addAction(secondAction)
        }
        
        if var topController = UIApplication.shared.windows[0].rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true)
        }
    }
}
