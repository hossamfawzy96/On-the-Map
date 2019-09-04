//
//  StudentsInformation.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation
import MapKit

class StudentsInformation: NSObject {
    
    // MARK: Properties
    var studentsInformation: [StudentInformation]? = nil
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK:- StudentInformation Struct
    struct StudentInformation{
        
        // MARK:- Properties
        let createdAt: String
        let firstName: String
        let lastName: String
        let latitude: Double
        let longitude: Double
        let mapString: String
        let mediaURL: String
        let objectID: String
        let uniqueKey: String
        let updatedAt: String
        
        //MARK:- Initializer
        init(dictionary:[String: AnyObject]){
            createdAt = dictionary[UdacityClient.JSONResponseKeys.CreatedAt] as! String
            firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
            lastName  = dictionary[UdacityClient.JSONResponseKeys.LastName]  as! String
            latitude  = dictionary[UdacityClient.JSONResponseKeys.Latitude]  as! Double
            longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as! Double
            mapString = dictionary[UdacityClient.JSONResponseKeys.MapString] as! String
            mediaURL  = dictionary[UdacityClient.JSONResponseKeys.MediaURL]  as! String
            objectID  = dictionary[UdacityClient.JSONResponseKeys.ObjectID]  as! String
            uniqueKey = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as! String
            updatedAt = dictionary[UdacityClient.JSONResponseKeys.UpdatedAt] as! String
        }
    }
    
    //MARK:- Create StudentInformation list
    func studentsInformationFromResults(_ results: [[String: AnyObject]]){
        var information = [StudentInformation]()
        
        for result in results{
            information.append(StudentInformation(dictionary: result))
        }
        
        // Store all the structs in the singelton instance od studentsInformation
        studentsInformation = information
    }
    
    // MARK:- Shared Instance
    class func sharedInstance() -> StudentsInformation{
        struct Singelton{
            static var sharedInstance = StudentsInformation()
        }
        return Singelton.sharedInstance
    }
    
}



