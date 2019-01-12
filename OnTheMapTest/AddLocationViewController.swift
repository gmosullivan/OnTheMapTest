//
//  AddLocationViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 11/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var studentsLocation: UITextField!
    @IBOutlet weak var studentsURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isHidden = true
        studentsLocation.isHidden = false
        studentsURL.isHidden = false
        finishButton.isHidden = true
        activityIndicator.isHidden = true
    }
    
    @IBAction func performForwardGeocoding() {
        if studentsLocation.text != "" && studentsURL.text != "" {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let studentsLocation = self.studentsLocation.text
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(studentsLocation!) { placemarks, error in
                guard error == nil else {
                    self.displayError(error: "Unable to find location", "Please check network connection or enter a different location.")
                    return
                }
                guard let placemark = placemarks?.first else {
                    self.displayError(error: "Unable to find location", "Please check network connection or try another location.")
                    return
                }
                let location = placemark.location?.coordinate
                self.mapView.isHidden = false
                self.studentsLocation.isHidden = true
                self.studentsURL.isHidden = true
                self.finishButton.isHidden = false
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
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
