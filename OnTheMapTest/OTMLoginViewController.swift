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

    @IBAction func Login() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            //Display alert
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
                //handle error
                return
            }
            // Add check for valid status code
            // Add check to ensure result receive
            let range = Range(5..<data!.count)
            let result = data?.subdata(in: range)
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                //Display error
                return
            }
            guard let accountInfo = parsedResult["account"] as? [String:AnyObject] else {
                //Handle error
                return
            }
            guard let isRegistered = accountInfo["registered"] as? Bool else {
                print("No can do")
                return
            }
            if isRegistered {
                performUIUpdatesOnMain {
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
            } else {
                //Handle error
                return
            }
        }
        task.resume()
    }
    
    //MARK: - Keyboard Notification Functions
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if emailTextField.isEditing || passwordTextField.isEditing {
            view.frame.origin.y = -1 * getKeyboardHeight(notification)
        }
    }
    
    //MARK: - Text Field Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

