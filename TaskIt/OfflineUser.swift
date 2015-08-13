//
//  OfflineUser.swift
//  SwiftParseTemplate
//
//  Created by Kiran Kunigiri on 8/5/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.

import UIKit
import Parse
import Bolts

class OfflineUser : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "OfflineUser"
    }
    
    @NSManaged var username: String
}