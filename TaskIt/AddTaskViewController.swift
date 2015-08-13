//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 7/30/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse

protocol AddTaskViewControllerDelegate {
    func addTask(message: String)
    func addTaskCanceled(message: String)
}

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate: AddTaskViewControllerDelegate?
    var mainVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dueDatePicker.minimumDate = NSDate()
        self.view.backgroundColor = backgroundColor
        self.taskTextField.delegate = self
        self.subtaskTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTaskButtonTapped(sender: UIButton) {
        var task = Task()

        task.name = taskTextField.text.lowercaseString
        task.subtask = subtaskTextField.text.lowercaseString
        task.date = Date.toDisplayString(date: dueDatePicker.date)
        task.notificationDate = Date.toExactString(date: dueDatePicker.date)
        task.createdBy = currentUsername
        task.completed = false
        
        
        //Set up notifications
        var idString = NSUUID().UUIDString
        var notification = UILocalNotification()
        notification.alertBody = task.name.capitalizedString
        notification.fireDate = dueDatePicker.date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "TODO_CATEGORY"
        notification.userInfo = ["UUID": idString]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        // Update local info
        task.notificationUUID = idString
        task.pinInBackgroundWithBlock { (success, error) -> Void in
            // Go back to main VC
            self.dismissViewControllerAnimated(true, completion: nil)
            self.mainVC.tableView.reloadData()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
