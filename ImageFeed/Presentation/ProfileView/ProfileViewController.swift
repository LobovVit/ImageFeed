//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 10.10.2024.
//
import UIKit
import Kingfisher
import WebKit

class ProfileViewController: UIViewController {
    
    private let fontColor = UIColor(red: 174.0/255, green: 175.0/255, blue: 180.0/255, alpha: 1.0)
    private let userPicture: String = "UserAvatarPlaceholder"
    private let exitBtnPick: String = "exitBtnPick"
    private var profile: Profile?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenting?
    
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification,
                                                                             object: nil,
                                                                             queue: .main) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.updateAvatar()
        }
        
        alertPresenter = AlertPresenter(viewController: self)
        updateAvatar()
        addUserPicture(imageView: userPictureImageView)
        addUserName(label: userNameLabel)
        addUserLogin(label: userLoginLabel)
        addUserDescription(label: userDescription)
        addExitButton(button: exitBtn)
        updateProfileDetails(profile: profileService.profile)
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
    
    private func updateProfileDetails(profile: Profile?) {
        userNameLabel.text = profileService.profile?.name
        userLoginLabel.text = profileService.profile?.loginName
        userDescription.text = profileService.profile?.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.userPicURL,
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
