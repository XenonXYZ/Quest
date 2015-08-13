
//
//  LoginViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/9/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse

protocol LoginViewControllerDelegate {
    func reloadFriendView()
}
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var mainVC: ViewController!
    var delegate: LoginViewControllerDelegate!
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(self.actInd)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
        
            var username = self.usernameField.text
            var password = self.passwordField.text
            
            if count(username.utf16) < 1 || count(password.utf16) < 1 {
                var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 1 and password must be greater than 1", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                self.actInd.startAnimating()
                PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                    self.actInd.stopAnimating()
                    
                    if user != nil {
                        var alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        if let user = PFUser.currentUser() {
                            currentUsername = user.username!
                            ParseController.receiveTasks()
                            var userLevel = user["level"] as! Int
                            var userExperience = user["experience"] as! Int
                            NSUserDefaults.standardUserDefaults().setInteger(userLevel, forKey: kLevelKey)
                            NSUserDefaults.standardUserDefaults().setInteger(userExperience, forKey: kExperienceKey)
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.mainVC.reloadLocaldatastore()
                            self.mainVC.tableView.reloadData()
                            
                            self.mainVC.loginView.hidden = true
                            self.mainVC.friendView.hidden = false
                            self.mainVC.profileVC.updateProfile()
                            self.mainVC.friendVC.updateFriends()
                            
                        }
                    } else {
                        var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                })
            }
        } else {
            var alert = UIAlertView(title: "Error", message: "No internet connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }

    }
    
    @IBAction func signupAction(sender: UIButton) {
        mainVC.signupView.hidden = false
        mainVC.loginView.hidden = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
}
