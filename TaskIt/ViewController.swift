//
//  ViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 7/30/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskDetailViewControllerDelegate, AddTaskViewControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    var profileVC = ProfileViewController()
    @IBOutlet weak var profileView: UIView!
    var loginVC = LoginViewController()
    @IBOutlet weak var loginView: UIView!
    var signupVC = SignupViewController()
    @IBOutlet weak var signupView: UIView!
    var friendVC = FriendViewController()
    @IBOutlet weak var friendView: UIView!
    
    var currentTaskArray: [Task] = []
    var currentTodoTaskArray: [Task] = []
    var currentCompletedTaskArray: [Task] = []
    var currentNumberOfSections = 0
    
    var loginViewController: PFLogInViewController! = PFLogInViewController()
    var signupViewController: PFSignUpViewController! = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let user = PFUser.currentUser() {
            if Reachability.isConnectedToNetwork() {
                friendView.hidden = false
                loginView.hidden = true
                signupView.hidden = true
            }
        } else {
            self.friendView.hidden = true
        }
        
        self.view.backgroundColor = backgroundColor
        
        var color1 = UIColor ( red: 0.323, green: 0.9884, blue: 0.423, alpha: 1.0 ).CGColor
        var color2 = UIColor ( red: 0.2245, green: 0.7713, blue: 0.5071, alpha: 1.0 ).CGColor
        
        var frame = CGRectMake(0, 0, titleView.frame.size.width, titleView.frame.size.height)
        
        var titleGradient = CAGradientLayer()
        titleGradient.frame = frame
        titleGradient.colors = [color1, color2]
        titleGradient.startPoint = CGPoint(x: 0, y: 0)
        titleGradient.endPoint = CGPoint(x: 0, y: 1)
        
        titleView.layer.insertSublayer(titleGradient, atIndex: 0)
        
        // Setup View order
        //self.view.bringSubviewToFront(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadLocaldatastore()
//        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, tableView.numberOfSections())), withRowAnimation: UITableViewRowAnimation.Right)
        tableView.reloadData()
        self.tableView.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: View loads
    
    @IBAction func listButtonTapped(sender: UIButton) {
        self.tableView.hidden = false
        self.tableView.reloadData()
        self.profileView.hidden = true
        self.loginView.hidden = true
        self.signupView.hidden = true
        self.friendView.hidden = true
    }
    
    @IBAction func profileButtonTapped(sender: UIButton) {
        self.profileView.hidden = false
        self.profileVC.updateSelf()
        self.tableView.hidden = true
        self.loginView.hidden = true
        self.signupView.hidden = true
        self.friendView.hidden = true
    }
    
    @IBAction func socialButtonPressed(sender: UIButton) {
        if let user = PFUser.currentUser() {
            self.friendView.hidden = false
            self.loginView.hidden = true
            self.signupView.hidden = true
            self.profileView.hidden = true
            self.tableView.hidden = true
        } else {
            self.loginVC.viewDidLoad()
            self.loginView.hidden = false
            self.friendView.hidden = true
            self.profileView.hidden = true
            self.tableView.hidden = true
            self.signupView.hidden = true
        }
    }
    
    
    // MARK: TableView
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let thisTask = getTaskAtCell(indexPath)
            detailVC.detailTaskModel = thisTask
            detailVC.mainVC = self
            detailVC.delegate = self
        } else if segue.identifier == "showTaskAdd" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            addTaskVC.mainVC = self
            addTaskVC.delegate = self
        } else if segue.identifier == "loginSegue" {
            let destVC: LoginViewController = segue.destinationViewController as! LoginViewController
            destVC.mainVC = self
            self.loginVC = destVC
        } else if segue.identifier == "signupSegue" {
            let destVC: SignupViewController = segue.destinationViewController as! SignupViewController
            destVC.mainVC = self
            self.signupVC = destVC
        } else if segue.identifier == "friendSegue" {
            let destVC: FriendViewController = segue.destinationViewController as! FriendViewController
            destVC.mainVC = self
            self.friendVC = destVC
        } else if segue.identifier == "profileSegue" {
            let destVC: ProfileViewController = segue.destinationViewController as! ProfileViewController
            self.profileVC = destVC
        }
    }
    
    // UITableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentNumberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var currentSection = getSection(section)
        if currentSection == "To do" {
            return currentTodoTaskArray.count
        } else if currentSection == "Completed" {
            return currentCompletedTaskArray.count
        } else {
            println("ERROR ERROR MUST READ!")
            return 0
        }

    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var thisTask = currentTaskArray[indexPath.row]

        var currentSection = getSection(indexPath.section)
        if currentSection == "To do" {
            thisTask = currentTodoTaskArray[indexPath.row]
        } else if currentSection == "Completed" {
            thisTask = currentCompletedTaskArray[indexPath.row]
        } else {
            println("ERROR ERROR MUST READ!")
        }
        
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.taskLabel.text = thisTask.name
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = thisTask.date
        cell.backgroundColor = UIColor ( red: 0.9963, green: 1.0, blue: 0.8358, alpha: 1.0 )
        
        // Gesture Controller
        var sgr = UISwipeGestureRecognizer(target: self, action: Selector("cellSwipedRight:"))
        sgr.direction = UISwipeGestureRecognizerDirection.Right
        cell.addGestureRecognizer(sgr)
        
        return cell
    }
    
    func cellSwipedRight(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            var transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)
            var animation = CATransform3DMakeAffineTransform(transform)
            
            var cell = gestureRecognizer.view as! TaskCell
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.transform = transform
                }) { (finished) -> Void in
                    //Update the user exp and level
                    var indexPath = self.tableView.indexPathForCell(cell)!
                    if self.getSection(indexPath.section) == "To do" {
                        LevelController.addExperience(10)
                        println("Adding experience!")
                   self.profileVC.updateProfile()
                    }
                    
                    // Update the cell to switch
                    cell.removeGestureRecognizer(cell.gestureRecognizers![0] as! UIGestureRecognizer)
                    self.switchTaskCompletion(indexPath)

            }
        }
    }
    
    // UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.userInteractionEnabled = false
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var frame = CGRectMake(0, 0, tableView.bounds.size.width, 25)
        var headerView = UIView(frame: frame)
        headerView.backgroundColor = UIColor ( red: 0.8424, green: 1.0, blue: 0.8782, alpha: 1.0 )
        
        var labelFrame = CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)
        var label = UILabel(frame: labelFrame)
        label.text = tableView.dataSource?.tableView!(tableView, titleForHeaderInSection: section)
        label.font = UIFont(name: "PowerhouseEra", size: 18)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return getSection(section)
    }

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        deleteTask(indexPath)
    }
    
    // MARK: TaskDetailViewController Delegate
    func taskDetailEdited() {
        
    }
    
    // MARK: AddTaskViewController Delegate
    func addTaskCanceled(message: String) {

    }
    
    func addTask(message: String) {
        showAlert(message: message)
    }
    
    func showAlert(message: String = "Congratulations") {
        var alert = UIAlertController(title: "Change Made!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Parse Management Functions
    func deleteTask(indexPath: NSIndexPath) {
        var thisTask = Task()
        
        var currentSection = getSection(indexPath.section)
        if currentSection == "To do" {
            thisTask = currentTodoTaskArray[indexPath.row]
        } else if currentSection == "Completed" {
            thisTask = currentCompletedTaskArray[indexPath.row]
        } else {
            println("ERROR ERROR MUST READ!")
        }
        
        // Cancel notification
        ParseController.deleteNotification(thisTask)
        
        thisTask.deleteInBackground()
        thisTask.unpinInBackgroundWithBlock { (success, error) -> Void in
            self.reloadLocaldatastore()
            self.tableView.reloadData()
        }
//        reloadLocaldatastore()
//        tableView.reloadData()
    }
    
    func switchTaskCompletion(indexPath: NSIndexPath) {
        var thisTask = Task()
        
        var currentSection = getSection(indexPath.section)
        if currentSection == "To do" {
            thisTask = currentTodoTaskArray[indexPath.row]
        } else if currentSection == "Completed" {
            thisTask = currentCompletedTaskArray[indexPath.row]
        } else {
            println("ERROR ERROR MUST READ!")
        }
        
        thisTask.completed = !thisTask.completed
        thisTask.pinInBackgroundWithBlock { (success, error) -> Void in
            self.reloadLocaldatastore()
            self.tableView.reloadData()
        }
    }
    
    func getTaskAtCell(indexPath: NSIndexPath) -> Task {
        var thisTask = Task()
        
        var currentSection = getSection(indexPath.section)
        if currentSection == "To do" {
            thisTask = currentTodoTaskArray[indexPath.row]
        } else if currentSection == "Completed" {
            thisTask = currentCompletedTaskArray[indexPath.row]
        } else {
            println("ERROR ERROR MUST READ!")
        }
        
        return thisTask
    }
    
    func getSection(section: Int) -> String {
        if currentNumberOfSections == 1 {
            let testTask: Task = currentTaskArray[0]
            if testTask.completed == true {
                return "Completed"
            } else {
                return "To do"
            }
        } else {
            if section == 0 {
                return "To do"
            } else {
                return "Completed"
            }
        }
    }
    
    func reloadLocaldatastore() {
        currentTaskArray = ParseController.getTaskArray()
        currentTodoTaskArray = ParseController.getTodoTaskArray()
        currentCompletedTaskArray = ParseController.getCompletedTaskArray()
        currentNumberOfSections = ParseController.getNumberOfSections()
    }
    
    
    
    // MARK: Parse Login
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if !username.isEmpty || !password.isEmpty {
            return true
        } else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Failed to login")
    }
    
    // MARK: Parse signup
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Failed to signup")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User dismissed sign up.")
    }
    
    // MARK: Actions
    
    @IBAction func simpleAction(sender: UIButton) {
        self.presentViewController(self.loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func customAction(sender: UIButton) {
        self.performSegueWithIdentifier("custom", sender: self)
    }
    
    @IBAction func logoutAction(sender: UIButton) {
        PFUser.logOut()
    }

    
}

