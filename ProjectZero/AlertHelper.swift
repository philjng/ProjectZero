//
//  AlertHelper.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
//

import Foundation

import UIKit

class AlertHelper {
    
    class func warn(delegate: UIViewController, message: String) {
        
        let alert = UIAlertController(title: "_alert_title".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "_alert_ok".localized, style: UIAlertAction.Style.default, handler: nil))
        delegate.present(alert, animated: true, completion: nil)
    }
    
}
