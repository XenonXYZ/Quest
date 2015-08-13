//
//  AppDelegate.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 7/30/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse
import Bolts

let kVersionNumber = "1.0"
let kLoadedOnceKey = "loadedOnce"
let backgroundColor = UIColor(red:0.8594, green:1.0, blue:0.8895, alpha:1.0)
var currentUsername = "username"
let kLevelKey = "level"
let kExperienceKey = "experience"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Parse.
        Task.registerSubclass()
        OfflineUser.registerSubclass()
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("cIaFpHwMaQpDinwrwvc88YIpCyeB0NpkuEHAs1B0",
            clientKey: "hXnGem9Bzz6MiqaziWMkJbgooziAOCKbvJQfo6Ia")
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))  // types are UIUserNotificationType members
        
        if let user = PFUser.currentUser() {
            currentUsername = user.username!
            if Reachability.isConnectedToNetwork() {
                ParseController.receiveTasks()
            }
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kLoadedOnceKey) == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: kLoadedOnceKey)
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: kLevelKey)
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: kExperienceKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            var taskArray = [Task(), Task(), Task(), Task(), Task(), Task()]
            
            taskArray[0].name = "Tap me!"
            taskArray[0].subtask = "Get more information \r Tap each quest to learn more about the app. Quest will help you complete your tasks by treating them like a game!"
            taskArray[1].name = "Add a quest!"
            taskArray[1].subtask = "Press the plus button"
            taskArray[2].name = "Complete a quest"
            taskArray[2].subtask = "Swipe right to complete a quest. \r You can always uncomplete it by swiping again if you want to redo it later."
            taskArray[3].name = "Delete one!"
            taskArray[3].subtask = "Swipe left"
            taskArray[4].name = "View your profile"
            taskArray[4].subtask = "Check your stats there! \r Your rank information will be displayed, along with your experience points. Each completed task will give you 10 experience points!"
            taskArray[5].name = "Add friends"
            taskArray[5].subtask = "Create an account \r This is optional, but will enable you to add your friends to see their stats. You will also be able to sync your quests across multiple devices."
            
            for newTask in taskArray {
                newTask.date = Date.toDisplayString(date: NSDate().dateByAddingTimeInterval(3600))
                newTask.notificationDate = Date.toExactString(date: NSDate().dateByAddingTimeInterval(3600))
                newTask.createdBy = currentUsername
                newTask.completed = false
                
                //Set up notifications
                var idString = NSUUID().UUIDString
                var notification = UILocalNotification()
                notification.alertBody = newTask.name.capitalizedString
                notification.fireDate = NSDate().dateByAddingTimeInterval(3600)
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.category = "TODO_CATEGORY"
                notification.userInfo = ["UUID": idString]
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
                // Update local info
                newTask.notificationUUID = idString
                newTask.pin()
                println("pinning")
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        ParseController.sendTasks()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

