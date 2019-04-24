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
        createSource()
        amountTextField.delegate = self
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        
    }
    
    func createSource() {
        
        let cardParams = STPCardParams()
        //cardParams.name = "Jenny Rosen"
        cardParams.number = "5555555555554444"
        cardParams.expMonth = 12
        cardParams.expYear = 23
        cardParams.cvc = "424"
        
        let sourceParams = STPSourceParams.cardParams(withCard: cardParams)
        STPAPIClient.shared().createSource(with: sourceParams) { (source, error) in
            if let s = source, s.flow == .none && s.status == .chargeable {
                TeamImporter.shared.addCardChangeCard(source: source?.stripeID)
            }
        }
        
    }
    
  
    
    //Outlets
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var cardInfoLabel: UILabel!
    @IBOutlet weak var cardIconView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    
    
    
    //Properties
    var currentPaymentMethod: STPPaymentMethod?
    let cardField = STPPaymentCardTextField()
    var theme = STPTheme.default()
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
//        // Setup add card view controller
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: cardFieldViewController)
        present(navigationController, animated: true)
       
    }
    
//    // MARK: STPAddCardViewControllerDelegate
//
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//        // Dismiss add card view controller
//        dismiss(animated: true)
//    }
//
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
//        dismiss(animated: true)
//
//        print("Printing Strip response:\(token.allResponseFields)\n\n")
//        print("Printing Strip Token:\(token.tokenId)")
//       //TeamImporter.shared.addCardChangeCard(source: STPSource)
//
//    }
//
//
//
//
//
//
//
//    func addCard() {
//        title = "Card Field"
//        view.backgroundColor = UIColor.white
//        view.addSubview(cardField)
//        edgesForExtendedLayout = []
//        view.backgroundColor = theme.primaryBackgroundColor
//        cardField.backgroundColor = theme.secondaryBackgroundColor
//        cardField.textColor = theme.primaryForegroundColor
//        cardField.placeholderColor = theme.secondaryForegroundColor
//        cardField.borderColor = theme.accentColor
//        cardField.borderWidth = 1.0
//        cardField.textErrorColor = theme.errorColor
//        cardField.postalCodeEntryEnabled = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//        navigationController?.navigationBar.stp_theme = theme
//
//    }
//
//    @objc func done() {
//        let cardParams = STPCardParams()
//        //cardParams.name = "Jenny Rosen"
//        cardParams.number = "5555555555554444"
//        cardParams.expMonth = 12
//        cardParams.expYear = 23
//        cardParams.cvc = "424"
//
//        let sourceParams = STPSourceParams.cardParams(withCard: cardParams)
//        STPAPIClient.shared().createSource(with: sourceParams) { (source, error) in
//            if let s = source, s.flow == .none && s.status == .chargeable {
//                TeamImporter.shared.addCardChangeCard(source: source?.stripeID)
//            }
//        }
//        dismiss(animated: true, completion: nil)
//    }
    
//    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethod, didSelect paymentMethod: STPPaymentMethod) {
//        print("didSelectPaymentMethod")
//        currentPaymentMethod = paymentMethod
//    }
//
//    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
//        self.navigationController?.popViewController(animated: true)
//    }


   @IBAction func makePayment(_ sender: UIButton) {
    
    
    if let amount: String = amountTextField.text, amount.count > 0 {
        
        TeamImporter.shared.makePaymentSendAmount(amount: Double(amount))
    } else {
                let alertController = UIAlertController(title: "Warning", message: "Please enter amount", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(alertAction)
                present(alertController, animated: true)
                return
            }
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

