//
//  SignupViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/9/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse

protocol SignupViewControllerDelegate {
    func reloadFriendView()
}
class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var mainVC: ViewController!
    var delegate: SignupViewControllerDelegate!
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
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
    
    
    @IBAction func signupAction(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
        
            var username = self.usernameField.text
            var password = self.passwordField.text
            var email = self.emailField.text
            
            if count(username.utf16) < 1 || count(password.utf16) < 1 {
                var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 1 and password must be greater than 1", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else if count(email.utf16) < 8 {
                var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                self.actInd.startAnimating()
                
                var newUser = PFUser()
                newUser.username = username
                newUser.password = password
                newUser.email = email
                newUser["level"] = NSUserDefaults.standardUserDefaults().integerForKey(kLevelKey)
                newUser["experience"] = NSUserDefaults.standardUserDefaults().integerForKey(kExperienceKey)
                
                newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                    self.actInd.stopAnimating()
                    
                    if error != nil {
                        var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    } else {
                        ParseController.syncTasksToNewUsername(newUser.username!)
                        self.mainVC.friendView.hidden = false
                        self.mainVC.signupView.hidden = true
                        self.mainVC.profileVC.updateProfile()
                        var alert = UIAlertView(title: "Success", message: "Signed up", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                })
            }
        } else {
            var alert = UIAlertView(title: "Error", message: "No internet connection", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        mainVC.loginView.hidden = false
        mainVC.signupView.hidden = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
