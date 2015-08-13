//
//  LevelController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/11/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit

class LevelController {
    
    class func addExperience(addedExp: Int) {
        var currentExp = NSUserDefaults.standardUserDefaults().integerForKey(kExperienceKey)
        var currentLevel = NSUserDefaults.standardUserDefaults().integerForKey(kLevelKey)
        
        if currentExp + addedExp >= getTotalExperience() {
            if currentLevel < 10 {
                currentLevel++
                currentExp = 0
            }
        } else {
            currentExp += addedExp
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(currentLevel, forKey: kLevelKey)
        NSUserDefaults.standardUserDefaults().setInteger(currentExp, forKey: kExperienceKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getTasksRemaining() -> Int {
        var currentExperience = NSUserDefaults.standardUserDefaults().integerForKey(kExperienceKey)
        var expRemaining = getTotalExperience() - currentExperience
        var tasksRemaining = expRemaining/10
        return tasksRemaining
    }
    
    class func getExperienceRemainingText() -> String {
        return "Experience: \(NSUserDefaults.standardUserDefaults().integerForKey(kExperienceKey))/\(LevelController.getTotalExperience())"
    }
    
    class func getTotalExperience() -> Int {
        var totalExp = 0
        var currentLevel = NSUserDefaults.standardUserDefaults().integerForKey(kLevelKey)
        
        switch currentLevel {
        case 1:
            totalExp = 20
        case 2:
            totalExp = 50
        case 3:
            totalExp = 100
        case 4:
            totalExp = 200
        case 5:
            totalExp = 300
        case 6:
            totalExp = 500
        case 7:
            totalExp = 600
        case 8:
            totalExp = 700
        case 9:
            totalExp = 800
        case 10:
            totalExp = 1000
        default:
            println("Error unknown level reached")
        }
        
        return totalExp
    }
    
    class func getTitleForLevelText() -> String {
        var levelTitle = ""
        var currentLevel = NSUserDefaults.standardUserDefaults().integerForKey(kLevelKey)
        
        switch currentLevel {
        case 1:
            levelTitle = "Procrastinator"
        case 2:
            levelTitle = "Worker"
        case 3:
            levelTitle = "Productive Human"
        case 4:
            levelTitle = "Quest Burner"
        case 5:
            levelTitle = "Guardian of Work"
        case 6:
            levelTitle = "Pure Worker"
        case 7:
            levelTitle = "Quest Saiyan"
        case 8:
            levelTitle = "Destroyer of Tasks"
        case 9:
            levelTitle = "Task Master"
        case 10:
            levelTitle = "Productivity King"
        default:
            println("Error unknown level reached")
        }
        
        return levelTitle
    }
    
    class func getImageForLevel() -> UIImage {
        var currentImage = UIImage(named: "1Level")
        var currentLevel = NSUserDefaults.standardUserDefaults().integerForKey(kLevelKey)
        
        switch currentLevel {
        case 1:
            currentImage = UIImage(named: "1Level")
        case 2:
            currentImage = UIImage(named: "2Level")
        case 3:
            currentImage = UIImage(named: "3Level")
        case 4:
            currentImage = UIImage(named: "4Level")
        case 5:
            currentImage = UIImage(named: "5Level")
        case 6:
            currentImage = UIImage(named: "6Level")
        case 7:
            currentImage = UIImage(named: "7Level")
        case 8:
            currentImage = UIImage(named: "8Level")
        case 9:
            currentImage = UIImage(named: "9Level")
        case 10:
            currentImage = UIImage(named: "10Level")
        default:
            println("Error unknown level reached")
        }
        
        return currentImage!
        
    }
    
    class func getImageForGivenLevel(level: Int) -> UIImage {
        var currentImage: UIImage!
        
        switch level {
        case 1:
            currentImage = UIImage(named: "1Level")
        case 2:
            currentImage = UIImage(named: "2Level")
        case 3:
            currentImage = UIImage(named: "3Level")
        case 4:
            currentImage = UIImage(named: "4Level")
        case 5:
            currentImage = UIImage(named: "5Level")
        case 6:
            currentImage = UIImage(named: "6Level")
        case 7:
            currentImage = UIImage(named: "7Level")
        case 8:
            currentImage = UIImage(named: "8Level")
        case 9:
            currentImage = UIImage(named: "9Level")
        case 10:
            currentImage = UIImage(named: "10Level")
        default:
            println("Error unknown level reached")
        }
        
        return currentImage!
        
    }
}