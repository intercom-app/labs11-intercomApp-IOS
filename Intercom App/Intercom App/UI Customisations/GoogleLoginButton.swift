//
//  GoogleLoginButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//


import UIKit

let kGoogleLoginButtonBackgroundColor = UIColor(displayP3Red: 255/255, green: 99/255, blue: 83/255, alpha: 1)
let kGoogleLoginButtonTintColor = UIColor.white
let kGoogleLoginButtonCornerRadius: CGFloat = 13.0

class GoogleLoginButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = kGoogleLoginButtonBackgroundColor
        self.layer.cornerRadius = kGoogleLoginButtonCornerRadius
        self.tintColor = kGoogleLoginButtonTintColor
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
    }
    
}
