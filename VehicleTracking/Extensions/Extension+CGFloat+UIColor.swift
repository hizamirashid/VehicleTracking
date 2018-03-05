//
//  Extension+UIColor.swift
//  VehicleTracking
//
//  Created by Norhizami  on 06/03/2018.
//  Copyright © 2018 Media Prima Digital - Norhizami. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
