//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 10.10.2024.
//
import UIKit

class ProfileViewController: UIViewController {
    
    private let fontColor = UIColor(red: 174.0/255, green: 175.0/255, blue: 180.0/255, alpha: 1.0)
    private let userPicture: String = "userPick"
    private let exitBtnPick: String = "exitBtnPick"
    private let userName: String = "Екатерина Новикова"
    private let userLogin: String = "@ekaterina_nov"
    private let userDescription: String = "Hello, World!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        addUserPicture(userPicture: userPicture)
        addUserName(userName: userName)
        addUserLogin(userLogin: userLogin)
        addUserDescription(userDescription: userDescription)
        addExitButton()
    }
    
    private func addUserPicture(userPicture: String) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: userPicture)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                                     imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     imageView.widthAnchor.constraint(equalToConstant: 70),
                                     imageView.heightAnchor.constraint(equalToConstant: 70)])
    }
    
    private func addUserName(userName: String) {
        let label = UILabel()
        label.text = userName
        label.textColor = .white
        label.font = .systemFont(ofSize: .init(23), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 98)])
    }
    
    private func addUserLogin(userLogin: String) {
        let label = UILabel()
        label.text = userLogin
        label.textColor = fontColor
        label.font = .systemFont(ofSize: .init(13), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 129)])
    }
    
    private func addUserDescription(userDescription: String) {
        let label = UILabel()
        label.text = userDescription
        label.textColor = .white
        label.font = .systemFont(ofSize: .init(17), weight: .medium)
        label.tag = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150)])
    }
    
    private func addExitButton() {
        let button = UIButton()
        let image = UIImage(named: exitBtnPick)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 33),
                                     button.widthAnchor.constraint(equalToConstant: 44),
                                     button.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    @objc
    private func didTapButton() {
        for view in view.subviews {
            if view.viewWithTag(1) != nil  {
                view.removeFromSuperview()
            }
        }
        addUserDescription(userDescription: "Хочу выйти")
    }
}
