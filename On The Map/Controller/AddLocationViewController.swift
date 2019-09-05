//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var URL: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    
    //MARK:- Properties
    var keyboardShowm = false
    let textFieldDelegate = TextFieldDelegate()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = textFieldDelegate
        URL.delegate = textFieldDelegate
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK:- Actions
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        checkInput {
            self.updateUI(enabled: false)
            
            // Show spinner
            let spinner = SpinnerViewController()
            spinner.createSpinnerView(parent: self)
            
            // Geocodes the location string
            let geocoder = CLGeocoder()
            var coordinates:CLLocationCoordinate2D!
            
            geocoder.geocodeAddressString(self.location.text!) {(placemarks, error) -> Void in
                
                if(error != nil){
                    AlertViewController().showError(title: "Finding Location", message: "Failed to geocode your location!", parent: self)
                }
                if let placemark = placemarks?.first {
                    coordinates = placemark.location!.coordinate
                    
                    // Create annotation Point for the student location using the geocoded location coordinates
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates!
                    annotation.title = placemark.name
                    
                    let storyboard = UIStoryboard (name: "Main", bundle: nil)
                    
                    //present the map view ti show the students's place
                    let controller = storyboard.instantiateViewController(withIdentifier: "finishAddLocation") as! ShowLocationViewController
                    controller.location = annotation
                    controller.mediaURL = self.URL.text!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                self.updateUI(enabled: true)
                spinner.removeSpinnerView()
                
            }
        }
    }
    
    //MARK:- Functions
    private func checkInput(completionHandlerForCheckInput: @escaping() -> Void){
        guard (location.text! != "") else{
            AlertViewController().showError(title: "Missing Information", message: "Please enter you location; ex: Mountain View, CA", parent: self)
            return
        }
        
        guard(URL.text! != "") else{
            AlertViewController().showError(title: "Missing Information", message: "Please enter your URL; ex: https://udacity.com", parent: self)
            return
        }
        
        completionHandlerForCheckInput()
    }
    
    private func updateUI(enabled: Bool){
        
        if(enabled){
            location.text = ""
            URL.text = ""
            
            location.resignFirstResponder()
            URL.resignFirstResponder()
        }
        
        findLocation.isEnabled = enabled
        
    }
}
