//
//  AlertViewController.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/3/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    func showError(title: String, message: String, parent: UIViewController){
        let controller = UIAlertController()
        controller.title = title
        controller.message = message
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        parent.present(controller, animated: true, completion: nil)
    }
}
