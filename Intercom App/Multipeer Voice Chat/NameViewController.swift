//
//  NameViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class NameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func unwindToNameViewController(segue: UIStoryboardSegue) { textField.becomeFirstResponder() }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If a stored value in UserDefaults is available when the app starts, use it and immediately segue to AddViewController
        let ourDefaults = UserDefaults.standard
        if let storeDisplayName = ourDefaults.object(forKey: "displayName") as? String {
            name = storeDisplayName
            performSegue(withIdentifier: "segueToAddViewController", sender: self)
        }
        
        // Always have keyboard up when entering this view controller
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        name = textField.text
        performSegue(withIdentifier: "segueToAddViewController", sender: self)
        return true
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! AddViewController
        let callData = CallData(displayName: name)
        dest.callData = callData
    }

}
