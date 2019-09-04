//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 8/31/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

extension UdacityClient{
    
    // MARK:- Constants
    struct Constants {
        
        // MARK:- URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
    }
    
    // MARK:- Methods
    struct Methods{
        static let Session = "/session"
        static let User = "/users/{key}"
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK:- JSON Response Keys
    struct JSONResponseKeys{
        // MARK:- Authentication
        static let Account = "account"
        static let Session = "session"
        
        // MARK:- Account
        static let Key = "key"
        static let Registered = "registered"
        
        // MARK:- Session
        static let Expiration = "expiration"
        static let ID = "id"
        
        //MARK:- Map Results
        static let MapResults = "results"
        
        //MARK:- StudentInformation
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName  = "lastName"
        static let Latitude  = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL  = "mediaURL"
        static let ObjectID  = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        
        //MARK:- User Public Data
        static let PublicFirstName = "first_name"
        static let PublicLastName  = "last_name"
        
    }
    
    // MARK:- URL Keys
    struct URLKeys{
        static let UserKey = "key"
    }
    
    //MARK:- Parameter Keys
    struct ParameterKeys{
        static let Limit = "limit"
        static let Order = "order"
    }
}
