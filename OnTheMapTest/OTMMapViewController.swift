//
//  OTMMapViewController.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 02/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

import UIKit

class OTMMapViewController: UIViewController {

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
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }

}
