//
//  SettingsViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/3/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = backgroundColor
        self.versionLabel.text = kVersionNumber
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
