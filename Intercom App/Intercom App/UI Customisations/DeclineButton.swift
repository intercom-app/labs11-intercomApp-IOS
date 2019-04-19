//
//  DeclineButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

let kDeclineButtonBackgroundColor = UIColor(displayP3Red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
let kDeclineButtonTintColor = UIColor.white
let kDeclineButtonCornerRadius: CGFloat = 6.0

class DeclineButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
        //self.backgroundColor = kDeclineButtonBackgroundColor
        self.layer.cornerRadius = kDeclineButtonCornerRadius
        self.tintColor = UIColor.red
        self.setTitleColor(.red, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    }
    
}
