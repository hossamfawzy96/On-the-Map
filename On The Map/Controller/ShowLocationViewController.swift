//
//  ShowLocationViewController.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import MapKit

class ShowLocationViewController: UIViewController, MKMapViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Properties
    var location:MKPointAnnotation!
    var mediaURL: String!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add student's location to the map
        self.mapView.addAnnotations([location])
        
        // Zoom in the map
        let span = MKCoordinateSpan(latitudeDelta:0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:- MapViewFunctions
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
    
    //MARK:- Actions
    @IBAction func submit(_ sender: Any) {
        let spinner = SpinnerViewController()
        spinner.createSpinnerView(parent: self)
        
        UdacityClient.sharedInstance().postStudentLocation(mapString: location.title!, mediaURL: mediaURL!, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude){(success, error) in
            performUIUpdatesOnMain {
                if success{
                    self.completePost()
                }else{
                    AlertViewController().showError(title: "Posting Location", message: error!, parent: self)
                }
            }
            spinner.removeSpinnerView()
        }
    }
    
    //MARK:- Functions
    private func completePost(){
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabbedView")
        self.present(controller, animated: true, completion: nil)
    }
}
