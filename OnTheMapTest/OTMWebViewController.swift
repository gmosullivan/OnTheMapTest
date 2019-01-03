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

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
    }

}
