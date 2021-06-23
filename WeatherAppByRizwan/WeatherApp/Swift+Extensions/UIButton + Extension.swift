//
//  UIButton + Extension.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func applyButtonCornerRadius(_cornerRadius:CGFloat) {
        self.layer.cornerRadius = _cornerRadius
    }
}
