//
//  utils.swift
//  Chat
//
//  Created by tzviki fisher on 15/07/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGRect {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        
        return label.frame
}
}
