//
//  BillingViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Stripe

class BillingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        
    }
    //Outlets
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var cardInfoLabel: UILabel!
    @IBOutlet weak var cardIconView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    
    
    //Properties
    var cardFullInfo: STPPaymentCardTextField?
    var pulledUser: Users?
    let cardFieldViewController = CardFieldViewController()
    
    //Functions
    func updateViews(){
       // guard let cardNumber = cardFullInfo?.cardNumber else { return }
       // let cardLast4 = String(cardNumber.suffix(4))
        guard let balance = TeamImporter.shared.teamMembers?.accountBalance else {
          return creditLabel.text = "Balance: $0" }
        creditLabel.text = "Balance: $\(balance)"
        TeamImporter.shared.fetchLast4 { (last4) in
            DispatchQueue.main.async {
                guard let last4 = last4 else {
                    return self.cardInfoLabel.text = "Need Enter Card Info" }
                self.cardInfoLabel.text = "\(last4)"
            }
        }
        
        }
   

    //Actions

    
    @IBAction func editCardInfo(_ sender: UIBarButtonItem) {
        
        let navigationController = UINavigationController(rootViewController: cardFieldViewController)
        present(navigationController, animated: true, completion: nil)
        
       
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//        navigationController?.pushViewController(addCardViewController, animated: true)
        
    }

   @IBAction func makePayment(_ sender: UIButton) {
    
    
            guard let amount = amountTextField.text else {
                let alertController = UIAlertController(title: "Warning", message: "Please enter amount in the field", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(alertAction)
                present(alertController, animated: true)
                return
            }
    
    }
    
}


extension BillingViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: Int(self.amountTextField.text!)!) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
}
