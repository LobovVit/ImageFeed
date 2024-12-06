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
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var isAuthorizing: Bool = false
    private var alertPresenter: AlertPresenting?
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "Vector")
        
        return view
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            fetchProfile(token)
        } else if !isAuthorizing {
            isAuthorizing = true
            navigateToAuthviewController()
        }
        alertPresenter = AlertPresenter(viewController: self)
        self.view.backgroundColor = UIColor(named: "ypBlack")
        self.view.addSubview(logoImageView)
        setConstraints(for: logoImageView)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func navigateToAuthviewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    private func setConstraints(for logoImageView: UIImageView) {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
    
}


extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWith code: String) {
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            self.dismiss(animated: true) { [weak self] in
                guard let self else { return }
                self.fetchOAuthToken(vc, code)
            }
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController, token: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            print("authviewcontroller dismissed?")
            
            guard let token = self.storage.token else {
                print("no token found.")
                return
            }
            
            fetchProfile(token)
        }
    }
    
    private func fetchOAuthToken(_ vc: AuthViewController, _ code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [ weak self ] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                didAuthenticate(vc, token: token)
            case .failure:
                showAlert()
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username, token: token) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                print("ERR: Failed to obtain user profile: \(error.localizedDescription)")
                break
            }
        }
    }
    
    private func showAlert() {
        DispatchQueue.main.async { [weak self] in
          guard let self else { return }
          let alertModel = AlertModel(
            title: "Ошибка",
            message: "Не удалось войти в систему",
            buttonText: "Ok",
            completion: { self.navigateToAuthviewController() }
          )
          self.alertPresenter?.showAlert(for: alertModel)
        }
    }
}
