//
//  ViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 17/12/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import UIKit

class OTMLoginViewController: UIViewController {

    let method = "https://onthemap-api.udacity.com/v1/session"
    var request = URLRequest(url: URL(string: method))
    let session = URLSession.shared
    let task = session.dataTask(with: request) {data, response, error in
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

