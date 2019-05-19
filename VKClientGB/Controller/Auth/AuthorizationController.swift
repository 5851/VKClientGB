//
//  AuthorizationController.swift
//  VKClientGB
//
//  Created by Максим on 18/05/2019.
//  Copyright © 2019 MaksimEliseev. All rights reserved.
//

import UIKit
import WebKit

class AuthorizationController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVK()
    }
    
    private func setupVK() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6988292"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"), // 262144 + 2 + 4 + 8192
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        webview.navigationDelegate = self
        let request = URLRequest(url: urlComponents.url!)
        webview.load(request)
    }
}

extension AuthorizationController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        if let token = params["access_token"] {
            Session.shared.token = token
            print(token)
        }
        
        if let userId = params["user_id"] {
            Session.shared.userId = Int(userId) ?? 0
            print(userId)
        }
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "showMainScreen", sender: nil)
    }
}
