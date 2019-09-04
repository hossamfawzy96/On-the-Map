//
//  TableViewController.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    var annotations: [MKPointAnnotation]!
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        annotations = mapAnnotationsFromStudentsInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK:- TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  annotations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInformation")!
        let studentInformation = annotations[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = studentInformation.title
        cell.detailTextLabel?.text  = studentInformation.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let toOpen = annotations[(indexPath as NSIndexPath).row].subtitle {
            let url = URL(string: toOpen)
            if(url == nil){
                AlertViewController().showError(title: "URL", message: "The provided URL is not correct", parent: self )
            }else{
                app.open(url!)
            }
        }else{
            AlertViewController().showError(title: "URL", message: "There is no URL provided or it's a wrong URL", parent: self )
        }
    }
    
    //MARK:- Actions
    @IBAction func logout(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSession(){ (success,error)in
            performUIUpdatesOnMain {
                if success{
                    self.completeLogout()
                }else{
                    AlertViewController().showError(title: "Logout Failed", message: error!, parent: self )
                }
            }
        }
    }
    
    //MARK:- Functions
    private func mapAnnotationsFromStudentsInformation() ->[MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()
        
        for studentInformation in StudentsInformation.sharedInstance().studentsInformation!{
            // create the coordinate from latitude and longitude
            let latitude  = CLLocationDegrees(studentInformation.latitude)
            let longitude = CLLocationDegrees(studentInformation.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // prepare personal info of the student
            let firstName = studentInformation.firstName
            let lastName  = studentInformation.lastName
            let mediaURL  = studentInformation.mediaURL
            
            // create the student's annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            // add to the map annotations
            annotations.append(annotation)
            
        }
        
        return annotations
    }
   
    private func completeLogout() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "login")
        present(controller, animated: true, completion: nil)
    }
}
