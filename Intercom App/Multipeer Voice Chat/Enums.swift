//
//  ControlStatus.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreGraphics

enum ControlStatus {
    case on
    case off
}

enum ButtonAlpha: RawRepresentable {
    typealias RawValue = CGFloat
    
    case on
    case off
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case 0.4:
            self = .on
        case 1.0:
            self = .off
        default:
            return nil
        }
    }
    
    var rawValue: CGFloat {
        switch self {
        case .on:
            return 0.4
        case .off:
            return 1
        }
    }

}
