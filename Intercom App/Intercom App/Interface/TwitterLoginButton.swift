//
//  TwitterLoginButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/21/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//


import UIKit

let kTwitterLoginButtonBackgroundColor = UIColor(displayP3Red: 85/255, green: 172/255, blue: 239/255, alpha: 1)
let kTwitterLoginButtonTintColor = UIColor.white
let kTwitterLoginButtonCornerRadius: CGFloat = 13.0

class TwitterLoginButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }

    private func configureUI() {
        self.backgroundColor = kTwitterLoginButtonBackgroundColor
        self.layer.cornerRadius = kTwitterLoginButtonCornerRadius
        self.tintColor = kTwitterLoginButtonTintColor
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
    }
}
