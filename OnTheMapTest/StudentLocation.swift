//
//  StudentLocation.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 03/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

struct StudentLocation {
    
    //MARK: - Constants
    let studentUniqueKey: String
    let studentFirstName: String
    let studentLastName: String
    let studentLatitude: Float
    let studentLongitude: Float
    let studentMapString: String
    let studentURL: String
    
    //MARK: - Initializers
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        studentUniqueKey = dictionary["uniqueKey"] as! String
        studentFirstName = dictionary["firstName"] as! String
        studentLastName = dictionary["lastName"] as! String
        studentLatitude = dictionary["latitude"] as! Float
        studentLongitude = dictionary["longitude"] as! Float
        studentMapString = dictionary["mapString"] as! String
        studentURL = dictionary["mediaURL"] as! String
    }
    
}
