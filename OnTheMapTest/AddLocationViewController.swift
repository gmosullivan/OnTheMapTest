//
//  AddLocationViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 11/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var studentsLocation: UITextField!
    @IBOutlet weak var studentsURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func performForwardGeocoding() {
        if studentsLocation.text != "" && studentsURL.text != "" {
            let studentsLocation = self.studentsLocation.text
            let geocoder = CLGeocoder()
            
        } else {
            displayError(error: "No Location or URL Added", "Please enter your location and a URL.")
        }
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
