//
//  OTMTableViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 08/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

import UIKit

class OTMTableViewController: UITableViewController {
    
    var locations: [StudentLocation] = [StudentLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locations", for: indexPath)
        let location = locations[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = "\(location.studentFirstName) \(location.studentLastName)"
        cell.detailTextLabel?.text = "\(location.studentMapString)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "OTMWebViewController") as! OTMWebViewController
        let locationURL = locations[indexPath.row].studentURL
        viewController.url = URL(string: locationURL)!
        self.navigationController!.pushViewController(viewController, animated: true)
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
            self.locations = locations
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
