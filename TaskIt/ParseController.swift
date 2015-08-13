//
//  ParseController.swift
//  SwiftParseTemplate
//
//  Created by Kiran Kunigiri on 8/6/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class ParseController {
    
    // Sets up the offline user for localdatastore
    class func setupOfflineUser() {
        var offlineUser = OfflineUser()
        offlineUser.username = currentUsername
        offlineUser.pinInBackground()
    }
    
    func setupOnlineUser() {
        
    }
    
    // Creates the task in localdatastore
    class func createTask(name: String, subtask: String, date: NSDate, completed: Bool) {
        var taskOne = Task()
        taskOne.createdBy = currentUsername
        taskOne.name = name
        taskOne.subtask = subtask
        taskOne.completed = completed
        
        taskOne.date = Date.toDisplayString(date: date)
        taskOne.pin()
    }
    
    class func syncTasksToNewUsername(username: String) {
        // Syncs all offline tasks to use the new username, used during signup
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        query.whereKey("createdBy", equalTo: currentUsername)
        
        var taskArray: [Task] = []
        
        var result = query.findObjects()!
        taskArray = result as! [Task]
        
        for task in taskArray {
            task.createdBy = username
            task.pinInBackground()
            task.saveEventually()
        }
        
        currentUsername = username
    }
    
    class func receiveTasks() {
        // Returns the whole array of tasks
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        
        query.whereKey("createdBy", equalTo: currentUsername)
        
        var taskArray: [Task] = []
        
        var result = query.findObjects()!
        taskArray = result as! [Task]
        
        for task in taskArray {
            task.unpin()
        }
        
        let query2 = PFQuery(className: "Task")
        
        query2.whereKey("createdBy", equalTo: currentUsername)
        
        var taskArray2: [Task] = []
        
        var result2 = query2.findObjects()!
        taskArray2 = result2 as! [Task]
        
        for task in taskArray2 {
            task.pin()
        }
    }
    
    class func clearTasks() {
        // Returns the whole array of tasks
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        
        query.whereKey("createdBy", equalTo: currentUsername)
        
        var taskArray: [Task] = []
        
        var result = query.findObjects()!
        taskArray = result as! [Task]
        
        for task in taskArray {
            task.unpin()
        }
    }
    
    
    class func sendTasks() {
        // Returns the whole array of tasks
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        
        query.whereKey("createdBy", equalTo: currentUsername)
        
        var taskArray: [Task] = []
        
        var result = query.findObjects()!
        taskArray = result as! [Task]
        
        for task in taskArray {
            task.save()
        }
    }
    
    // Returns the whole array of tasks
    class func getTaskArray() -> [Task] {
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        query.whereKey("createdBy", equalTo: currentUsername)
        
        var taskArray: [Task] = []
        
        var result = query.findObjects()!
        println("Task array Retrieved \(result.count)")
        taskArray = result as! [Task]
        
        return taskArray
    }
    
    // Returns the whole array of tasks
    class func getTodoTaskArray() -> [Task] {
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        query.whereKey("createdBy", equalTo: currentUsername)
        query.whereKey("completed", equalTo: false)
        
        var taskArray: [Task] = []
        
        var result = query.findObjects()!
        println("Task array Retrieved \(result.count)")
        taskArray = result as! [Task]
        
        return taskArray
    }
    
    // Returns the whole array of tasks
    class func getCompletedTaskArray() -> [Task] {
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        query.whereKey("createdBy", equalTo: currentUsername)
        query.whereKey("completed", equalTo: true)
        
        var taskArray: [Task] = []
        
        var result = query.findObjects()!
        println("Task array Retrieved \(result.count)")
        taskArray = result as! [Task]
        
        return taskArray
    }
    
    // Returns a task at the specific index
    class func getTaskAtIndex(index: Int) -> Task {
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        query.whereKey("createdBy", equalTo: currentUsername)
        
        var indexTask = Task()
        
        var result = query.findObjects()!
        println("Index task retrieved \(result.count)")
        indexTask = result[index] as! Task
        
        return indexTask
    }
    
    
    // Returns the number of sections to display for the tableview
    class func getNumberOfSections() -> Int {
        let query = PFQuery(className: "Task")
        query.fromLocalDatastore()
        query.whereKey("createdBy", equalTo: currentUsername)
        query.whereKey("completed", equalTo: false)
        
        var numberOfSections = 0
        var todoValid = false
        var completedValid = false
        
        var result = query.findObjects()!
        println("Query 1 for section Retrieved \(result.count)")
        if result.count > 0 {
            todoValid = true
            println("todo valid is true!")
        }
        
        let query2 = PFQuery(className: "Task")
        query2.fromLocalDatastore()
        query2.whereKey("createdBy", equalTo: currentUsername)
        query2.whereKey("completed", equalTo: true)
        
        result = query2.findObjects()!
        
        println("Query 2 for section Retrieved \(result.count)")
        if result.count > 0 {
            completedValid = true
        }
        
        if todoValid && completedValid {
            numberOfSections = 2
        } else if todoValid || completedValid {
            numberOfSections = 1
        } else {
            println("NOTHING IS HAPPENING!!! \(todoValid)")
        }
        
        println("Number of sections is \(numberOfSections)")
        return numberOfSections
    }
    
    class func deleteNotification(task: Task) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
            if (notification.userInfo!["UUID"] as! String == task.notificationUUID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
    }
    
}