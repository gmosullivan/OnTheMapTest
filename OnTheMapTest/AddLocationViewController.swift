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

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var studentsLocation: UITextField!
    @IBOutlet weak var studentsURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsLocation.delegate = self
        studentsURL.delegate = self
        mapView.isHidden = true
        studentsLocation.isHidden = false
        studentsURL.isHidden = false
        finishButton.isHidden = true
        activityIndicator.isHidden = true
    }
    
    @IBAction func cancel() {
        dismiss(animated: true)
    }
    
    @IBAction func performForwardGeocoding() {
        if studentsLocation.text != "" && studentsURL.text != "" {
            UdacityClient.HTTPBodyValues.mapString = studentsLocation.text!
            UdacityClient.HTTPBodyValues.mediaURL = studentsURL.text!
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let usersLocation = self.studentsLocation.text
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(usersLocation!) { placemarks, error in
                guard error == nil else {
                    UdacityClient.sharedInstance().displayError(error: "Unable to find location", "Please check network connection or enter a different location.", self)
                    return
                }
                guard let placemark = placemarks?.first else {
                    UdacityClient.sharedInstance().displayError(error: "Unable to find location", "Please check network connection or enter a different location.", self)
                    return
                }
                let location = placemark.location?.coordinate
                UdacityClient.HTTPBodyValues.latitude = location!.latitude
                UdacityClient.HTTPBodyValues.longitude = location!.longitude
                self.mapView.isHidden = false
                self.studentsLocation.isHidden = true
                self.studentsURL.isHidden = true
                self.finishButton.isHidden = false
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        } else {
            UdacityClient.sharedInstance().displayError(error: "No Location or URL Added", "Please enter your location and a URL.", self)
        }
    }
    
    @IBAction func postNewLocation() {
        UdacityClient.sharedInstance().postNewLocation(self)
        /*
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String:Any] = [
            "uniqueKey": "1234",
            "firstName": "Gareth",
            "lastName": "OSullivan",
            "mapString": studentsLocation.text!,
            "mediaURL": studentsURL.text!,
            "latitude": 0.00,
            "longitude": 0.00
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            if parsedResult.count > 0 {
                self.dismiss(animated: true)
            } else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
        }
        task.resume()
        */
    }

}
