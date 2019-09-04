//
//  SpinnerViewController.swift
//  TheMovieManager
//
//  Created by Hossameldien Hamada on 9/3/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    //MARK:- LifeCycle
    override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK:- Functions
    func createSpinnerView(parent: UIViewController){
        parent.addChild(self)
        view.frame = parent.view.frame
        parent.view.addSubview(view)
        didMove(toParent: parent)
        
    }
    
    func removeSpinnerView(){
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    
}
