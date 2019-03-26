//
//  LoginViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

func background(_ block: @escaping () -> Void) {
    DispatchQueue.global(qos: .userInteractive).async(execute: block)
}

func UI(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

