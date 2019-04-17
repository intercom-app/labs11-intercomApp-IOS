//
//  CallButton.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

let kCallButtonBackgroundColor = UIColor(displayP3Red: 131/255, green: 175/255, blue: 164/255, alpha: 1)
let kCallButtonTintColor = UIColor.white
let kCallButtonCornerRadius: CGFloat = 6.0

class CallButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
       // self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = kCallButtonCornerRadius
        self.tintColor = kCallButtonTintColor
        //self.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    }
    
}
