//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/1/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import Foundation

// MARK: - TMDBClient (Convenient Resource Methods)

extension UdacityClient{
    
    //MARK:- Login
    func authenticateUser(userName: String, password: String, completionHandlerForLogin: @escaping(_ success: Bool, _ error: String?) -> Void){
        
        // Create Json
        let jsonBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}"
        
        // Initiate Login Request
        let _ = taskForPOSTMethod(Methods.Session, jsonBody: jsonBody){ (response,error) in
            
            if let error = error{
                completionHandlerForLogin(false,error.userInfo[NSLocalizedDescriptionKey] as? String)
            }else{
                if let account = response?[JSONResponseKeys.Account] as? [String: AnyObject]{
                    if let key = account[JSONResponseKeys.Key] as? String{
                        self.userKey = key
                        self.publicUserData(userKey: key, completionHandlerForPublicUserData: completionHandlerForLogin)
                    }else{
                        completionHandlerForLogin(false,"Could not find \(JSONResponseKeys.Key) in \(account)")
                    }
                }else{
                    completionHandlerForLogin(false,"Could not find \(JSONResponseKeys.Account) in \(response!)")
                }
            }
            
        }
    }
    
    //MARK:- Public User Data
    private func publicUserData(userKey: String, completionHandlerForPublicUserData: @escaping(_ success: Bool, _ error: String?) -> Void){
        var mutableMethod = Methods.User
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserKey, value: userKey)!
        
        // Initiate Public Data Request
        let _ = taskForGETMethod(mutableMethod){ (response, error) in
            if let error = error{
                completionHandlerForPublicUserData(false,error.userInfo[NSLocalizedDescriptionKey] as? String)
            }else{
                if let firstName = response?[JSONResponseKeys.PublicFirstName] as? String{
                    self.userFirstName = firstName
                }else{
                    completionHandlerForPublicUserData(false,"Could not find \(JSONResponseKeys.FirstName) in \(response!)")
                }
                
                if let lastName = response?[JSONResponseKeys.PublicLastName] as? String{
                    self.userLastName = lastName
                }else{
                    completionHandlerForPublicUserData(false,"Could not find \(JSONResponseKeys.LastName) in \(response!)")
                }
                self.downloadStudentsInformation(completionHandlerForDownloadStudentsInformation: completionHandlerForPublicUserData)
            }
            
        }
    }
    
    //MARK:- Delete Session
    func deleteSession(completionHandlerForDeleteSession: @escaping(_ success: Bool, _ error: String?) -> Void){
        let _ = taskForDeleteMethod(Methods.Session){ (response, error) in
            if let error = error{
                completionHandlerForDeleteSession(false,error.userInfo[NSLocalizedDescriptionKey] as? String)
            }else{
                completionHandlerForDeleteSession(true,nil)
            }
            
        }
    }
    
    //MARK:- Download StudentsInformation
    private func downloadStudentsInformation(completionHandlerForDownloadStudentsInformation: @escaping(_ success: Bool, _ error: String?)-> Void){
        
        let parameters = [ParameterKeys.Limit: "100" , ParameterKeys.Order: "-updatedAt"]
        
        let _ = taskForGETMethod(Methods.StudentLocation,skipParsedData: false, parameters: parameters as [String : AnyObject]){ (response,error) in
            if error != nil{
                completionHandlerForDownloadStudentsInformation(false,"Failed to download the Students' inforamtion")
            }else{
                if let result = response?[JSONResponseKeys.MapResults] as? [[String:AnyObject]]{
                    StudentsInformation.sharedInstance().studentsInformationFromResults(result)
                }else{
                    completionHandlerForDownloadStudentsInformation(false,"Could not find \(JSONResponseKeys.MapResults) in \(response!)")
                }
                completionHandlerForDownloadStudentsInformation(true,nil)
            }
            
        }
    }
    
    //MARK:- Post Student Location
    func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPostStudentLocation: @escaping(_ success: Bool, _ error: String?)-> Void){
  
        let json = "{\"uniqueKey\": \"\( self.userKey!)\", \"firstName\": \"\(self.userFirstName!)\", \"lastName\": \"\( self.userLastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        let _ = taskForPOSTMethod(Methods.StudentLocation, skipParsedData:false, jsonBody: json){ (response,error) in
            if error != nil{
                completionHandlerForPostStudentLocation(false,"Failed to post your inforamtion")
            }else{
                self.downloadStudentsInformation(completionHandlerForDownloadStudentsInformation: completionHandlerForPostStudentLocation)
            }
        }
        
    }
    
    //MARK:- Direct to Signup
    func DirectToSignup(){
        guard let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated") else { return }
        UIApplication.shared.open(url)
    }
        
}
