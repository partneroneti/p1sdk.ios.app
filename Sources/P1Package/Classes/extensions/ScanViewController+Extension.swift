//
//  ScanViewController+Extension.swift
//  PartnerOneSDK
//
//  Created by Adriano Mazucato on 27/10/23.
//

import UIKit

extension ScanViewController {
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alert, animated: true, completion: nil)
    }
}
