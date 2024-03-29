//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Anna on 09.02.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController, AuthViewControllerDelegate {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var authLogoImage: UIImageView = {
        let logoImage = UIImage(named: "auth_screen_logo")
        let imageView = UIImageView(image: logoImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        configureConstraints()
    }
    
    @objc func logInButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let webViewViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController else {
            showErrorAlert()
            return
        }
        webViewViewController.delegate = self
        present(webViewViewController, animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YP Black")
    }
    
    func addSubviews() {
        view.addSubview(authLogoImage)
        view.addSubview(logInButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            authLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            logInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true)
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")}
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
