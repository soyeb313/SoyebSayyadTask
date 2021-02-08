//
//  WeatherDetailsViewController.swift
//  SoyebSayyadTask
//
//  Created by Mac on 08/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import UIKit
class Alert : NSObject{

  class func showAlert(alertTitle: String , alertMessage: String ,actionTitle: String)
  {
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let alertAction1 = UIAlertAction(title: actionTitle, style: .default){  (action) in
      
      }
    alert.addAction(alertAction1)
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    
    
  }
    
}
