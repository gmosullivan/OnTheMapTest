//
//  OTMWebViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 03/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

import UIKit
import WebKit

class OTMWebViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var urlString = "https://auth.udacity.com/sign-up"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView(urlString)
    }
    
    func loadWebView (_ url: String) {
        let request = URLRequest(url: URL(string: url)!)
        self.view.addSubview(webView)
        webView.load(request)
    }

}
