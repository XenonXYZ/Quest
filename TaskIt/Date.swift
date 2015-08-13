//
//  Date.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 7/30/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation

class Date {
    class func from (#year: Int, month: Int, day: Int) -> NSDate {
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        var date = gregorianCalendar?.dateFromComponents(components)
        
        return date!
    }
    
    class func toDisplayString(#date: NSDate) -> String {
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateStringFormatter.stringFromDate(date)
        
        return dateString
    }
    
    class func toDisplayDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var newDate = dateFormatter.dateFromString(date)
        return newDate!
    }
    
    // Information extraction methods for notifications
    class func toExactString(#date: NSDate) -> String {
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd-hh-mm-a"
        let dateString = dateStringFormatter.stringFromDate(date)
        
        return dateString
    }
    
    class func toExactDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-a"
        var newDate = dateFormatter.dateFromString(date)
        return newDate!
    }
}