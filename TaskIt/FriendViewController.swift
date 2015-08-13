//
//  FriendViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/10/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse

class FriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoginViewControllerDelegate, SignupViewControllerDelegate {

    var mainVC: ViewController!
    @IBOutlet weak var friendTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noInternetView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateFriends()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func reloadButtonPressed(sender: UIButton) {
        reloadFriendView()
    }
    
    func reloadFriendView() {
        updateFriends()
        tableView.reloadData()
    }
    
    func updateFriends() {
        
        if Reachability.isConnectedToNetwork() {
            println("INTERNET IS BACK!!!!")
            noInternetView.hidden = true
            self.tableView.reloadData()
        } else {
            var alert = UIAlertView(title: "Please connect to the internet", message: "An internet connection is requred to look at friends.", delegate: self, cancelButtonTitle: nil)
            noInternetView.hidden = false
            self.view.bringSubviewToFront(noInternetView)
            println("hahahhaha")
            //self.view.hidden = true
        }
    }
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        ParseController.sendTasks()
        ParseController.clearTasks()
        mainVC.reloadLocaldatastore()
        mainVC.tableView.reloadData()
        PFUser.logOutInBackground()
        mainVC.loginView.hidden = false
        mainVC.friendView.hidden = true
        mainVC.profileVC.updateProfile()
    }
    
    @IBAction func addFriendButtonPressed(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
            let query = PFUser.query()
            query!.whereKey("username", equalTo: friendTextField.text)
            
            if var friendUser = query?.getFirstObject() as? PFUser {
                if friendUser.username != PFUser.currentUser()?.username {
                    PFUser.currentUser()?.addUniqueObject(friendUser.username!, forKey: "friends")
                    PFUser.currentUser()?.save()
                    tableView.reloadData()
                }
            }
        } else {
            noInternetView.hidden = false
        }
    }
    
    
    
    
    // Tableview Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if Reachability.isConnectedToNetwork() {
            let friendArray: NSArray? = PFUser.currentUser()?.objectForKey("friends") as? NSArray
            
            if let arr = friendArray {
                println("\(arr.count) asdasdasd")
                count =  arr.count
            }
        }
        
        
        return count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var thisFriend = 0
        
        var cell: FriendCell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! FriendCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let friendArray: NSArray? = PFUser.currentUser()?.objectForKey("friends") as? NSArray
        var query = PFUser.query()
        var friendString = friendArray![indexPath.row] as! String
        query?.whereKey("username", equalTo: friendString)
        
        var friend: PFUser = query?.findObjects()?.first as! PFUser
        
        println("Got the array")
        if friendArray != [] {
            var username = friend.username
            cell.usernameLabel.text = username
            var level = friend.objectForKey("level") as! Int
            cell.levelLabel.text = "level: \(level)"
            cell.rankImageView.image = LevelController.getImageForGivenLevel(level)
            cell.backgroundColor = backgroundColor
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    // Tableview Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

}
