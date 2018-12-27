//
//  ViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 17/12/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import UIKit

class OTMLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Login() {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"gareth.osullivan@icloud.com\", \"password\": \"2469WdWa\"}}".data(using: .utf8)
        print(String(data: request.httpBody!, encoding: .utf8)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                //handle error
                return
            }
            // Add check for valid status code
            // Add check to ensure result receive
            let range = Range(5..<data!.count)
            let result = data?.subdata(in: range)
            print(String(data: result!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}

