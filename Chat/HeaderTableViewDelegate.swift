//
//  HeaderTableViewDelegate.swift
//  Chat
//
//  Created by tzviki fisher on 20/07/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

protocol HeaderTableViewDelegate  {
    func didScroll(withOffset offset:CGFloat)
    func didFinishSwipeLeft()
    func didFinishSwipeRight()
}
protocol SegDelegate  {
    func eventsClicked()
    func groupsClicked()
    func chatClicked()
}
