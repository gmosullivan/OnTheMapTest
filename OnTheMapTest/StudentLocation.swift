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
        studentLatitude = dictionary["latitude"] as! Float
        studentLongitude = dictionary["longitude"] as! Float
        if dictionary["mapString"] != nil {
            studentMapString = dictionary["mapString"] as! String
        } else {
            studentMapString = ""
        }
        studentURL = dictionary["mediaURL"] as! String
    }
    
    static func studentLoactionsFrom(results: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        return studentLocations
    }
}
