//
//  ViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 17/12/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import UIKit

class OTMLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func Login() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayError(error: "Missing email and/or password", "Please enter your email address and password.")
            return
        }
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 599 else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            if statusCode >= 300 && statusCode <= 399 {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            } else if statusCode >= 400 && statusCode <= 499 {
                self.displayError(error: "Invalid Credentials", "Please check your email and password are correct and try again")
                return
            } else if statusCode >= 500 {
                self.displayError(error: "Unable to Connect", "Please check your network connection and try again")
                return
            }
            let range = Range(5..<data!.count)
            let result = data?.subdata(in: range)
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            guard let accountInfo = parsedResult["account"] as? [String:AnyObject] else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            guard let isRegistered = accountInfo["registered"] as? Bool else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
                if isRegistered {
                    performUIUpdatesOnMain {
                        self.performSegue(withIdentifier: "Login", sender: self)
                    }
                } else {
                    self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                    return
            }
        }
        task.resume()
    }
    
    //MARK: - Text Field Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Error Functions
    
    func displayError(error: String, _ description: String) {
        print(error)
        let alert = UIAlertController(title: error, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

