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
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayStudentLocations()
        self.mapView.reloadInputViews()
    }
    
    //GET Student Locations
    
    func displayStudentLocations() {
        /*
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
            */
            for location in StudentLocation.locations {
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
            self.mapView.addAnnotations(self.annotations)
        /*
        }
        task.resume()
        */
    }
    
    // MARK: - MKMapViewDelegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let locationURL = view.annotation?.subtitle!
            if (locationURL?.contains("http"))! {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "OTMWebViewController") as! OTMWebViewController
                viewController.urlString = locationURL!
                self.navigationController!.pushViewController(viewController, animated: true)
            } else {
                UdacityClient.sharedInstance().displayError(error: "Invalid URL", "This does not appear to be a valid URL. Please try another student", self)
            }
        }
    }
    
    @IBAction func logout() {
        UdacityClient.sharedInstance().taskForLogout(self)
        /*
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.displayError(error: "Something went wrong!", "Unable to logout. Please try again later.")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.displayError(error: "Something went wrong!2", "Unable to logout. Please try again later.")
                return
            }
            let range = Range(5..<data!.count)
            let result = data?.subdata(in: range)
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: result!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                self.displayError(error: "Something went wrong!3", "Unable to logout. Please try again later.")
                return
            }
            guard let session = parsedResult["session"] as? [String:Any] else {
                self.displayError(error: "Something went wrong!", "Unable to logout. Please try again later.")
                return
            }
            if session.count > 0 {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true)
                }
            }
        }
        task.resume()
        */
    }
    
}
