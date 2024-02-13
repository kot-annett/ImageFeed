//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Anna on 09.02.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    private var delegate: AuthViewControllerDelegate?
    
    private var authLogoImage: UIImageView!
    private var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
    }
    
    @IBAction private func logInButtonTapped() {
        performSegue(withIdentifier: "ShowWebView", sender: nil)
    }
    
    func addSubviews() {
        let logoImage = UIImage(named: "auth_screen_logo")
        authLogoImage = UIImageView(image: logoImage)
        authLogoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authLogoImage)
        
        logInButton = UIButton(type: .system)
        logInButton.setTitle("Войти", for: .normal)
        logInButton.setTitleColor(UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0), for: .normal)
        logInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        logInButton.backgroundColor = .white
        logInButton.layer.cornerRadius = 16
        logInButton.layer.masksToBounds = true
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
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
