//
//  JoinGroupButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

let kJoinGroupButtonBackgroundColor = UIColor(displayP3Red: 1/255, green: 180/255, blue: 1/255, alpha: 1)
let kJoinGroupButtonTintColor = UIColor.white
let kJoinGroupButtonCornerRadius: CGFloat = 13.0

class JoinGroupButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
      //  self.backgroundColor = kJoinGroupButtonBackgroundColor
        self.layer.cornerRadius = kJoinGroupButtonCornerRadius
        self.tintColor = kJoinGroupButtonTintColor
        self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    }
    
}
