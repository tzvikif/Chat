//
//  AppDelegate.swift
//  Chat
//
//  Created by tzviki fisher on 28/06/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var members:[Person]?
    var groups:[Group]?
    var events:[Event]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        buildMembers()
        buildGroups()
        buildEvents()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func addMember(_ member:Person) {
        if self.members == nil  {
            self.members = [Person]()
        }
        self.members!.insert(member, at: self.members!.endIndex)
    }
    func buildMembers() {
        var p:Person=Person(lastLogin: Date(), userName: "Moshe", isOnline: true, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Jossi", isOnline: false, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Akiva", isOnline: true, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Jossi", isOnline: false, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Shalom", isOnline: true, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Michal", isOnline: false, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Elena", isOnline: true, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Zohar", isOnline: false, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Joe", isOnline: true, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "David", isOnline: true, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Naama", isOnline: false, chatPartners: nil)
        addMember(p)
        p=Person(lastLogin: Date(), userName: "Lior", isOnline: true, chatPartners: nil)
        addMember(p)
        
        self.members?.sort(by: {(p1:Person,p2:Person) -> Bool in
            return p1.userName < p2.userName
        })
    }
    func buildEvents()
    {
        var e:Event
        self.events = [Event]()
        for i in (0...20)
        {
            e = Event(eventName: "Event#\(i)")
            events!.append(e)
        }
    }
    func buildGroups()
    {
        self.groups = [Group]()
        var g:Group
        for i in (0...20)
        {
            g = Group(groupName: "Group#\(i)")
            groups!.append(g)
        }
        
    }
}

