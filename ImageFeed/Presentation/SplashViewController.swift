//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 01.11.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreen = "showAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = storage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreen, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreen {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreen)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.fetchOAuthToken(code)
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code: code, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success:
                self.switchToTabBarController()
            case.failure:
                print("ERR: SplashViewController.fetchOAuthToken")
            }
        })
    }
}
