//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 29.10.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    )
}

final class AuthViewController: UIViewController {
    
    private let ShowWebView:String = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebView {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(ShowWebView)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code, completion: { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
                switch result {
                case.success(_):
                    delegate?.authViewController(self, didAuthenticateWithCode: code)
                case.failure(_):
                    print("ERR: webViewViewController")
                }
            })
        }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
