//
//  Extensions.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
import UIKit

extension UIViewController {
    func ShowConnectionAlert() {
        let alert = UIAlertController(title: "No Connection", message: "This app needs internet connection in order to work.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
