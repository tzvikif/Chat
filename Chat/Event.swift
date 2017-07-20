//
//  Event.swift
//  Chat
//
//  Created by tzviki fisher on 18/07/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

class Event: NSObject {
    var name:String!
    init(eventName newName:String) {
        self.name = newName
    }
    override init() {
        name = "name missing"
    }
}
