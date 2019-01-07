//
//  OTMMapViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 02/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

import UIKit
import MapKit

class OTMMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Variables
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
    }
    
    //GET Student Locations
    
    func getStudentLocations() {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.")
                return
            }
            let locations = StudentLocation.studentLoactionsFrom(results: results)
            for location in locations {
                let lat = CLLocationDegrees(location.studentLatitude)
                let lon = CLLocationDegrees(location.studentLongitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let first = location.studentFirstName
                let last = location.studentLastName
                let url = location.studentURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = url
                self.annotations.append(annotation)
            }
            
        }
        task.resume()
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
