//
//  Task.swift
//  SwiftParseTemplate
//
//  Created by Kiran Kunigiri on 8/5/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.

import UIKit
import Parse
import Bolts

class Task : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Task"
    }
    
    @NSManaged var name: String
    @NSManaged var subtask: String
    @NSManaged var completed: Bool
    @NSManaged var createdBy: String
    @NSManaged var date: String
    @NSManaged var notificationDate: String
    @NSManaged var notificationUUID: String
}