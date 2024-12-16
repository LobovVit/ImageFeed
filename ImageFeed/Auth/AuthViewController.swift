//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 29.10.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWith code: String)
    func didAuthenticate(_ vc: AuthViewController, token: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        guard let image = UIImage(named: "unsplash_ic") else { return UIImageView() }
        view.image = image
        
        return view
    }()
    
    private lazy var signinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(named: "ypBlack") ?? UIColor.black, for: .normal)
        button.backgroundColor = UIColor(named: "ypWhite") ?? UIColor.white
        button.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "ypBlack")
        self.view.addSubview(logoView)
        self.view.addSubview(signinButton)
        
        setConstraints(for: logoView)
        setConstraints(for: signinButton)
    }
    
    @objc private func signinButtonTapped() {
        navigateToWebView()
    }
    
    private func setConstraints(for imageView: UIImageView) {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    private func setConstraints(for button: UIButton) {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48),
            button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
        ])
    }
    
    private func navigateToWebView() {
        let vc = WebViewViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        delegate?.authViewController(self, didAuthenticateWith: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
