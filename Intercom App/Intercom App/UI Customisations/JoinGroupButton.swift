//
//  JoinGroupButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

let kJoinGroupButtonBackgroundColor = UIColor(displayP3Red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
let kJoinGroupButtonTintColor = UIColor.white
let kJoinGroupButtonCornerRadius: CGFloat = 13.0

class JoinGroupButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
       // self.backgroundColor = kJoinGroupButtonBackgroundColor
        self.layer.cornerRadius = kJoinGroupButtonCornerRadius
        self.setTitleColor(.blue, for: .normal)
        self.tintColor = UIColor.blue
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blue.cgColor
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    }
    
}
