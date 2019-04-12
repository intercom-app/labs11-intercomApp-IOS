//
//  BillingViewController.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 4/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class BillingViewController: UIViewController {
    
    override func viewDidLoad() {
        updateViews()
    }
    
    //Outlets
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var cardInfoLabel: UILabel!
    @IBOutlet weak var cardIconView: UIImageView!
    @IBOutlet weak var cardNameField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardDateField: UITextField!
    @IBOutlet weak var cardCVCField: UITextField!
    @IBOutlet weak var updatePaymentButton: UIButton!
    
    //Properties
    
    
    //Functions
    func updateViews(){
    
    }
    
    //Actions
    
    @IBAction func updatePaymentClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
    }
    
    
    
    
}
