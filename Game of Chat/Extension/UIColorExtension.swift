//
//  UIColorExtension.swift
//  Game of Chat
//
//  Created by Felix Lin on 10/12/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
