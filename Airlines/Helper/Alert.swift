//
//  Alert.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import UIKit

struct Alert {
    
    private init() {}
    
    static func show(on vc: UIViewController, title: String, message: String, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if let actions = actions {
                for action in actions {
                    alert.addAction(action)
                }
            } else {
                alert.addAction(UIAlertAction(title: "Close", style: .destructive))
            }
            
            vc.present(alert, animated: true)
        }
    }
    
    static func loader(on vc: UIViewController, delay: DispatchTime) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "Loading..", preferredStyle: .alert)
            vc.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true)
            }
        }
    }
}
