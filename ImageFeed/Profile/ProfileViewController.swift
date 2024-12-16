//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 10.10.2024.
//
import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar()
    func displayProfileData(name: String?, loginName: String?, bio: String?)
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    private let fontColor = UIColor(red: 174.0/255, green: 175.0/255, blue: 180.0/255, alpha: 1.0)
    private let userPicture: String = "UserAvatarPlaceholder"
    private let exitBtnPick: String = "exitBtnPick"
    private var alertPresenter: AlertPresenting?
    var presenter: ProfileViewPresenterProtocol?
    
    private lazy var userPictureImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: userPicture))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: .init(23), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userLoginLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = fontColor
        label.font = .systemFont(ofSize: .init(13), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userDescription: UILabel =  {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: .init(17), weight: .medium)
        label.tag = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exitBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: exitBtnPick)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "ExitButton" 
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfileViewPresenter(view: self)
        presenter?.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        alertPresenter = AlertPresenter(viewController: self)
        updateAvatar()
        addUserPicture(imageView: userPictureImageView)
        addUserName(label: userNameLabel)
        addUserLogin(label: userLoginLabel)
        addUserDescription(label: userDescription)
        addExitButton(button: exitBtn)
    }
    
    private func addUserPicture(imageView: UIImageView ) {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                                     imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     imageView.widthAnchor.constraint(equalToConstant: 70),
                                     imageView.heightAnchor.constraint(equalToConstant: 70)])
    }
    
    private func addUserName(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 98)])
    }
    
    private func addUserLogin(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 129)])
    }
    
    private func addUserDescription(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150)])
    }
    
    private func addExitButton(button: UIButton) {
        view.addSubview(button)
        NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 33),
                                     button.widthAnchor.constraint(equalToConstant: 44),
                                     button.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    @objc
    private func didTapButton() {
        showAlert()
    }
    
    
    func displayProfileData(name: String?, loginName: String?, bio: String?) {
        userNameLabel.text = name
        userLoginLabel.text = loginName
        userDescription.text = bio
    }
    
    internal func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.userPicURL,
            let url = URL(string: profileImageURL)
        else { return }
        userPictureImageView.kf.setImage(with: url, placeholder: UIImage(named: userPicture))
    }
    
    private func resetView() {
        userNameLabel.text = "User"
        userLoginLabel.text = "Login"
        userDescription.text = "Description"
        userPictureImageView.image = UIImage(systemName: userPicture)
    }
    
    private func resetToken() {
        guard OAuth2TokenStorage.shared.removeToken() else {
            print("ERR: reset token")
            return
        }
    }
    
    private func resetPhotos() {
        ImageListService.shared.resetPhotos()
    }
    
    private func resetCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    
    private func showAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: "Выход",
                message: "Хотите выйти?",
                buttonText: "Да",
                completion: { self.resetAccount() },
                secondButtonText: "Нет",
                secondCompletion: { self.dismiss(animated: true) }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
    
    private func switchToSplashVC() {
        guard let window = UIApplication.shared.windows.first else { return }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
    
    private func resetAccount() {
        resetToken()
        resetView()
        resetPhotos()
        resetCookies()
        switchToSplashVC()
    }
    
}
