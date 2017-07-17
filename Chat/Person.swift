//
//  Person.swift
//  Chat
//
//  Created by tzviki fisher on 01/07/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

class Person: NSObject {
    let lastLogin:Date
    var userName:String
    var isOnline:Bool
    var chatPartners:[Person]?
    init(lastLogin:Date,userName:String,isOnline:Bool,chatPartners:[Person]?=nil) {
        self.lastLogin = lastLogin
        self.userName = userName
        self.isOnline = isOnline
        self.chatPartners = chatPartners
    }
}
