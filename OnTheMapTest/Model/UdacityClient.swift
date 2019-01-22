//
//  UdacityClient.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 15/01/2019.
//  Copyright © 2019 Locust Redemption. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    // MARK: Shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    func handleRequest( _ request: URLRequest, _ viewController: UIViewController, withCompletionHandler: @escaping( _ result: Data?, _ error: String?) -> Void) -> URLSessionDataTask {
        let request = request
        let task = session.dataTask(with: request) { data, response, error in
            self.checkForErrorInTask(data, response, error: error) { (success, error) in
                self.checkForError(success, error, viewController)
                self.checkStatusCode(data, inResponse: response, error as? Error) { (success, error) in
                    self.checkForError(success, error, viewController)
                    withCompletionHandler(data, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    //MARK: Account Functions
    func taskForLogin(_ viewController: UIViewController) {
        let loginURL = buildURL(Constants.onTheMapHost, withPathExtension: Constants.onTheMapSessionPath)
        var request = URLRequest(url: loginURL)
        request.httpMethod = Methods.post
        request.addValue(HTTPValues.json, forHTTPHeaderField: HTTPHeaders.accept)
        request.addValue(HTTPValues.json, forHTTPHeaderField: HTTPHeaders.contentType)
        let body = [HTTPBodyKeys.udacity: [HTTPBodyKeys.username: HTTPBodyValues.username, HTTPBodyKeys.password: HTTPBodyValues.password]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
            return
        }
        handleRequest(request, viewController) { (result, error) in
            self.parseDataFromRange(result, error, viewController) { (result, error) in
                print(result!)
                guard let accountInfo = result![JSONResponseKeys.account] as? [String:AnyObject] else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
                return
                }
                guard let isRegistered = accountInfo[JSONResponseKeys.registered] as? Bool else {
                self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
                return
                }
                guard let accountId = accountInfo[JSONResponseKeys.key] as? String else {
                    self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
                    return
                }
                userId.userId = accountId
                if isRegistered {
                    self.getUserDetails(viewController) { (success) in
                        if success {
                            self.getStudentLocations(viewController) { (success) in
                                if success {
                                    performUIUpdatesOnMain {
                                        viewController.performSegue(withIdentifier: "Login", sender: viewController)
                                    }
                                } else {
                                    self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
                                }
                            }
                        } else {
                            self.displayError(error: "Something weng wrong!", "Please check your network connection or try again later.", viewController)
                        }
                    }
                }
            }
        }
    }
    
    func taskForLogout( _ viewController: UIViewController) {
        let logoutURL = buildURL(Constants.onTheMapHost, withPathExtension: Constants.onTheMapSessionPath)
        var request = URLRequest(url: logoutURL)
        request.httpMethod = Methods.delete
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == HTTPValues.xsrfToken { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: HTTPHeaders.xsrfToken)
        }
        handleRequest(request, viewController) { (result, error) in
            self.parseDataFromRange(result, error, viewController) { (result, error) in
                guard let session = result![JSONResponseKeys.session] as? [String:Any] else {
                    self.displayError(error: "Something went wrong!", "Unable to logout. Please try again later.", viewController)
                    return
                }
                if session.count > 0 {
                    performUIUpdatesOnMain {
                        viewController.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func getUserDetails( _ viewController: UIViewController, _ userCompletionHandler: @escaping( _ success: Bool) -> Void) {
        let userInfoURL = buildURL(Constants.onTheMapHost, withPathExtension: Constants.onTheMapUsersPath)
        var mutableURL: URL = userInfoURL
        mutableURL = substituteKeyIn(url: userInfoURL, key: Constants.id, value: userId.userId)!
        let request = URLRequest(url: mutableURL)
        handleRequest(request, viewController) { (result, error) in
            self.parseDataFromRange(result, error, viewController) { (result, error) in
                guard let userFirstName = result![JSONResponseKeys.firstName] as? String else {
                    userCompletionHandler(false)
                    return
                }
                UdacityClient.HTTPBodyValues.firstName = userFirstName
                guard let userLastName = result![JSONResponseKeys.lastName] as? String else {
                    userCompletionHandler(false)
                    return
                }
                UdacityClient.HTTPBodyValues.lastName = userLastName
                userCompletionHandler(true)
            }
        }
    }
    
    // MARK: Student Location Functions
    func getStudentLocations( _ viewController: UIViewController, locationsCompletionHandler: @escaping( _ success: Bool) -> Void) {
        let queryItems = [ParameterKeys.limit : ParameterValues.limit, ParameterKeys.order : ParameterValues.order] as [String:AnyObject] 
        let studentLocationURL = buildURL(Constants.parseHost, Constants.parsePath, withQueryItems: queryItems)
        var request = URLRequest(url: studentLocationURL)
        request.addValue(HTTPValues.applicationId, forHTTPHeaderField: HTTPHeaders.applicationId)
        request.addValue(HTTPValues.apiKey, forHTTPHeaderField: HTTPHeaders.apiKey)
        handleRequest(request, viewController) { (result, error) in
            self.parseResult(result, error, viewController) { (result, error) in
                guard let results = result![JSONResponseKeys.results] as? [[String:AnyObject]] else {
                    locationsCompletionHandler(false)
                    return
                }
                StudentLocation.locations = StudentLocation.studentLoactionsFrom(results: results)
                locationsCompletionHandler(true)
            }
        }
    }
    
    func postNewLocation( _ viewController: UIViewController) {
        let newLocationURL = buildURL(Constants.parseHost, withPathExtension: Constants.parsePath)
        var request = URLRequest(url: newLocationURL)
        request.httpMethod = Methods.post
        request.addValue(HTTPValues.applicationId, forHTTPHeaderField: HTTPHeaders.applicationId)
        request.addValue(HTTPValues.apiKey, forHTTPHeaderField: HTTPHeaders.apiKey)
        request.addValue(HTTPValues.json, forHTTPHeaderField: HTTPHeaders.contentType)
        let body: [String:Any] = [
            HTTPBodyKeys.uniqueKey: HTTPBodyValues.uniqueKey,
            HTTPBodyKeys.firstName: HTTPBodyValues.firstName,
            HTTPBodyKeys.lastName: HTTPBodyValues.lastName,
            HTTPBodyKeys.mapString: HTTPBodyValues.mapString,
            HTTPBodyKeys.mediaURL: HTTPBodyValues.mediaURL,
            HTTPBodyKeys.latitude: HTTPBodyValues.latitude,
            HTTPBodyKeys.longitude: HTTPBodyValues.longitude
            ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
            return
        }
        handleRequest(request, viewController) { (result, error) in
            self.parseResult(result, error, viewController) { (result, error) in
                if result!.count > 0 {
                    viewController.dismiss(animated: true)
                } else {
                    self.displayError(error: "Something went wrong!", "Please check your network connection or try again later.", viewController)
                    return
                }
            }
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
