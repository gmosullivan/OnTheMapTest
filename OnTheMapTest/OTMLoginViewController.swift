//
//  ViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 17/12/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import UIKit

class OTMLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Login() {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    }
    
}

