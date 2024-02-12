//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Anna on 09.02.2024.
//

import UIKit
import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

final class WebViewViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView.navigationDelegate = self
        updateProgress()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func loadView() {
        super.loadView()
        loadWebView()
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                updateProgress()
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController {
    private func loadWebView() {
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func code(from url: URL?) throws -> String {
        guard
            let url = url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }),
            let code = codeItem.value
        else {
            throw NetworkError.badWebKitResponse
        }
        return code
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard let code = try? code(from: navigationResponse.response.url) else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        delegate?.webViewViewController(self, didAuthenticateWithCode: code)
    }
}
    
    
//    private func code(from navigationAction: WKNavigationAction) -> String? {
//        if
//            let url = navigationAction.request.url,
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
//}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
