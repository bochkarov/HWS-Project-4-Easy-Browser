//
//  ViewController.swift
//  HWS Project 4 Easy Browser
//
//  Created by Bochkarov Valentyn on 23/08/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var homePage: String?
    var websites = ["hackingwithswift.com", "apple.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))

        toolbarItems = [progressButton, spacer, back, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        if let openPage = homePage {
            let url = URL(string: "https://www." + openPage)!
                  webView.load(URLRequest(url: url))
        }
        
      
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

    }
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open", message: "Choose the website", preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac,animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://www." + action.title!)!
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            let acAccess = UIAlertController(title: "Access denied", message: "Restricted resource", preferredStyle: .alert)
                             let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                 acAccess.addAction(okAction)
             //                    print(website)
                                 present(acAccess, animated: true)
        }
 
        decisionHandler(.cancel)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

