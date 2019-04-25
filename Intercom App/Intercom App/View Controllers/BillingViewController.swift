//
//  BillingViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Stripe

class BillingViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        TeamImporter.shared.bvc = self
        amountTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        
    }
    
    
    
    
    
    //Outlets
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var cardInfoLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    
    
    //Properties
    let cardFieldViewController = CardFieldViewController()
    
    //Functions
    func updateViews(){
//         guard let cardNumber = cardFullInfo?.cardNumber else { return }
//         let cardLast4 = String(cardNumber.suffix(4))
        guard let balance = TeamImporter.shared.teamMembers?.accountBalance else {
             creditLabel.text = "Balance: $0"
            TeamImporter.shared.fetchLast4 { (last4) in
                DispatchQueue.main.async {
                    guard let last4 = last4 else {
                        return self.cardInfoLabel.text = "Need Enter Card Info" }
                    self.cardInfoLabel.text = "Card **** **** **** " + last4
                }
            }
            return
        }
        creditLabel.text = "Balance: $\(balance)"
        TeamImporter.shared.fetchLast4 { (last4) in
            DispatchQueue.main.async {
                guard let last4 = last4 else {
                    return self.cardInfoLabel.text = "Need Enter Card Info" }
                self.cardInfoLabel.text = "Card **** **** **** " + last4
            }
        }
        
    }
    
    
    //Actions
    @IBAction func editCardInfo(_ sender: UIBarButtonItem) {
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: cardFieldViewController)
        present(navigationController, animated: true)
        
    }
    
    @IBAction func makePayment(_ sender: UIButton) {
        
        
        if let amount: String = amountTextField.text, amount.count > 0 {
            
            TeamImporter.shared.makePaymentSendAmount(amount: amount) { (updatedAccountBalance) in
                DispatchQueue.main.async {
                    self.creditLabel.text = "Balance: $\(updatedAccountBalance)"
                }
            }
        } else {
            let alertController = UIAlertController(title: "Warning", message: "Please enter amount", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            return
        }
        amountTextField.text = nil
        amountTextField.resignFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

