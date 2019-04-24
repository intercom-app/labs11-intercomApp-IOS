//
//  InviteButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

let kInviteButtonBackgroundColor = UIColor(displayP3Red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
let kInviteButtonTintColor = UIColor.white
let kInviteButtonCornerRadius: CGFloat = 13.0

class InviteButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
        // self.backgroundColor = kInviteButtonBackgroundColor
        self.layer.cornerRadius = kInviteButtonCornerRadius
        self.setTitleColor(.blue, for: .normal)
        self.tintColor = UIColor.blue
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.blue.cgColor
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
    }
    
}
