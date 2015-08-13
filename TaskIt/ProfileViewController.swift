//
//  ProfileViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/10/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {


    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var tasksRemainingLabel: UILabel!
    @IBOutlet weak var experienceRemainingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateProfile()
    }
    
    func updateProfile() {
        if let user = PFUser.currentUser() {
            self.usernameLabel.text = user.username
        } else {
            self.usernameLabel.hidden = true
        }
        
        self.titleLabel.text = LevelController.getTitleForLevelText()
        self.rankImage.image = LevelController.getImageForLevel()
        self.tasksRemainingLabel.text = "tasks until next level: \(LevelController.getTasksRemaining())"
        self.levelLabel.text = "Level \(NSUserDefaults.standardUserDefaults().integerForKey(kLevelKey))"
        self.experienceRemainingLabel.text = "Experience: \(NSUserDefaults.standardUserDefaults().integerForKey(kExperienceKey))/\(LevelController.getTotalExperience())"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSelf() {
        if let user = PFUser.currentUser() {
            self.usernameLabel.text = user.username
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
