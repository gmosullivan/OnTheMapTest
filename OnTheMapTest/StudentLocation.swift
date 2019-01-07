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
        if dictionary["uniqueKey"] != nil {
            studentUniqueKey = dictionary["uniqueKey"] as! String
        } else {
            studentUniqueKey = "This is weird"
        }
        if dictionary["firstName"] != nil {
            studentFirstName = dictionary["firstName"] as! String
        } else {
            studentFirstName = ""
        }
        if dictionary["lastName"] != nil {
            studentLastName = dictionary["lastName"] as! String
        } else {
            studentLastName = ""
        }
        if dictionary["latitude"] != nil {
            studentLatitude = dictionary["latitude"] as! Float
        } else {
            studentLatitude = 0.00
        }
        if dictionary["longitude"] != nil {
            studentLongitude = dictionary["longitude"] as! Float
        } else {
            studentLongitude = 0.00
        }
        if dictionary["mapString"] != nil {
            studentMapString = dictionary["mapString"] as! String
        } else {
            studentMapString = ""
        }
        if dictionary["mediaURL"] != nil {
            studentURL = dictionary["mediaURL"] as! String
        } else {
            studentURL = "https://failblog.cheezburger.com/"
        }
    }
    
    static func studentLoactionsFrom(results: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        return studentLocations
    }
}
