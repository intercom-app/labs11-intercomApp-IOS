//
//  JoinGroupButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

let kJoinGroupButtonBackgroundColor = UIColor(displayP3Red: 1/255, green: 66/255, blue: 205/255, alpha: 1)
let kJoinGroupButtonTintColor = UIColor.white
let kJoinGroupButtonCornerRadius: CGFloat = 6.0

class JoinGroupButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
       // self.backgroundColor = kJoinGroupButtonBackgroundColor
        self.layer.cornerRadius = kJoinGroupButtonCornerRadius
        self.setTitleColor(kJoinGroupButtonBackgroundColor, for: .normal)
        self.tintColor = UIColor.gray
        self.layer.borderWidth = 1
        self.layer.borderColor = kJoinGroupButtonBackgroundColor.cgColor
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    }
    
}
