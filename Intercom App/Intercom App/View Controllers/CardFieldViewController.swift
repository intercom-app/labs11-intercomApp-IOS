//
//  CardFieldViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Stripe

class CardFieldViewController: UIViewController {
    
    let cardField = STPPaymentCardTextField()
    var theme = STPTheme.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Card Field"
        view.backgroundColor = UIColor.white
        view.addSubview(cardField)
        edgesForExtendedLayout = []
        view.backgroundColor = theme.primaryBackgroundColor
        cardField.backgroundColor = theme.secondaryBackgroundColor
        cardField.textColor = theme.primaryForegroundColor
        cardField.placeholderColor = theme.secondaryForegroundColor
        cardField.borderColor = theme.accentColor
        cardField.borderWidth = 1.0
        cardField.textErrorColor = theme.errorColor
        cardField.postalCodeEntryEnabled = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationController?.navigationBar.stp_theme = theme
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        if cardField.isValid {
            let cardParams = STPCardParams()
            //cardParams.name = "Jenny Rosen"
            cardParams.number = cardField.cardNumber
            cardParams.expMonth = cardField.expirationMonth
            cardParams.expYear = cardField.expirationYear
            cardParams.cvc = cardField.cvc
            cardParams.address.postalCode = cardField.postalCode
            
            let sourceParams = STPSourceParams.cardParams(withCard: cardParams)
            STPAPIClient.shared().createSource(with: sourceParams) { (source, error) in
                if let s = source, s.flow == .none && s.status == .chargeable {
                    TeamImporter.shared.addCardChangeCard(source: source?.stripeID)
                }
            }
           dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 15
        cardField.frame = CGRect(x: padding,
                                 y: padding,
                                 width: view.bounds.width - (padding * 2),
                                 height: 50)
    }
    
}
