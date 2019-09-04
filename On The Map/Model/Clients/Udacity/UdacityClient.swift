//
//  UdacityClient.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 8/31/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation

// MARK: - TMDBClient: NSObject
class UdacityClient: NSObject{
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var userKey : String!
    var userFirstName: String!
    var userLastName: String!
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    //MARK:- GET
    func taskForGETMethod(_ method: String,skipParsedData: Bool? = true,parameters:[String: AnyObject]? = nil, jsonBody: String? = nil, completionHandlerForGET: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters,withPathExtension: method))
        
        // Make the request
        return makeRequestWithCompletionHandler(skipParsedData:skipParsedData,request: request as URLRequest, errorDomain: "taskForGETMethod", comletionHandlerForMakeRequest: completionHandlerForGET)
        
    }
    
    //MARK:- POST
    func taskForPOSTMethod(_ method: String,skipParsedData: Bool? = true, parameters:[String: AnyObject]? = nil,jsonBody: String? = nil, completionHandlerForPOST: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters,withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let json = jsonBody{
            request.httpBody = json.data(using: String.Encoding.utf8)
        }
        
        
        // Make the request
        return makeRequestWithCompletionHandler(skipParsedData:skipParsedData,request: request as URLRequest, errorDomain: "taskForPOSTMethod", comletionHandlerForMakeRequest: completionHandlerForPOST)
        
    }
    
    //MARK:- DELETE
    func taskForDeleteMethod(_ method: String, completionHandlerForDelete: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(url: udacityURLFromParameters(withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        return makeRequestWithCompletionHandler(request: request as URLRequest, errorDomain: "taskForDeleteMethod", comletionHandlerForMakeRequest: completionHandlerForDelete)
    }
    
    //MARK:- Make Request
    private func makeRequestWithCompletionHandler(skipParsedData: Bool? = true,request: URLRequest, errorDomain: String, comletionHandlerForMakeRequest: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void)-> URLSessionDataTask{
        // Make the request
        let task = session.dataTask(with: request as URLRequest){ (data,response,error)in
            
            func sendError(_ error: String){
                let userInfo = [NSLocalizedDescriptionKey : error]
                comletionHandlerForMakeRequest(nil, NSError(domain: errorDomain, code: 1, userInfo: userInfo))
            }
            
            // Guard for error
            guard(error == nil) else{
                sendError("There was an error with your request: Check the internet connection!")
                return
            }
            
            // Guard for response status
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                sendError("Wrong Credentials!")
                return
            }
          
            // Guard for returned data
            guard let data = data  else{
                sendError("No data was returned by the request!")
                return
                
            }
           
            // parse and use data
            self.convertDataWithCompletionHandler(skipParsedData:skipParsedData!,data, completionHandlerForConvertData: comletionHandlerForMakeRequest)
        }
        
        task.resume()
        
        return task
        
    }
    
    //MARK:- Parse JSON
    private func convertDataWithCompletionHandler(skipParsedData: Bool = true,_ data: Data, completionHandlerForConvertData:(_ result: AnyObject?, _ error: NSError?) -> Void){
        
        var parsedResult: AnyObject! = nil
        let range = 5..<data.count
        var dataToParse: Data? = nil
        
        if(skipParsedData){
            // if the request is directed udacity api
            dataToParse = data.subdata(in: range)
        }else{
            // if the request directed to parse api no need to skip the first five chars
            dataToParse = data
        }
       
        do{
            parsedResult = try JSONSerialization.jsonObject(with: dataToParse!, options: .allowFragments) as AnyObject
            completionHandlerForConvertData(parsedResult,nil)
        }catch{
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        
    }
    
    //MARK:- URL Creation
    private func udacityURLFromParameters(_ parameters: [String: AnyObject]? = nil,withPathExtension: String? = nil) -> URL{
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters{
            for (key, value) in parameters{
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
        
    }
    
    //MARK:- Substitute Key for Value in Methods
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String?{
        if method.range(of: "{\(key)}") != nil{
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        }else{
            return nil
        }
    }
    
    // MARK:- Shared Instance
    class func sharedInstance() -> UdacityClient{
        struct Singelton{
            static var sharedInstance = UdacityClient()
        }
        return Singelton.sharedInstance
    }
    
}
