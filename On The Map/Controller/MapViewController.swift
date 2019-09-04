//
//  LoggedInViewController.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/1/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Properties
    var annotations: [MKPointAnnotation]!
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        annotations = mapAnnotationsFromStudentsInformation()
        self.mapView.addAnnotations(annotations)
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
    
    //MARK:- MapView Functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string: toOpen)
                if(url == nil){
                    AlertViewController().showError(title: "URL", message: "The provided URL is not correct", parent: self )
                }else{
                    app.open(url!)
                }
                
            }else{
                AlertViewController().showError(title: "URL", message: "There is no URL provided", parent: self )
            }
        }
    }
    
    //MARK:- Functions
    private func completeLogout() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "login")
        present(controller, animated: true, completion: nil)
    }
    
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
}
