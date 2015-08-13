//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 7/30/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Parse

@objc protocol TaskDetailViewControllerDelegate {
    optional func taskDetailEdited()
}

class TaskDetailViewController: UIViewController, UITextViewDelegate {

    var detailTaskModel: Task!
    var mainVC: ViewController!
    
    
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var subtaskTextView: UITextView!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate: TaskDetailViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = backgroundColor
        
        self.dueDatePicker.minimumDate = NSDate()
        self.dueDatePicker.date = Date.toExactDate(detailTaskModel.notificationDate)
        self.taskTextView.text = detailTaskModel.name
        self.subtaskTextView.text = detailTaskModel.subtask
        
        self.subtaskTextView.delegate = self
        self.subtaskTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        detailTaskModel.name = taskTextView.text.lowercaseString
        detailTaskModel.subtask = subtaskTextView.text.lowercaseString
        detailTaskModel.date = Date.toDisplayString(date: dueDatePicker.date)
        detailTaskModel.notificationDate = Date.toExactString(date: dueDatePicker.date)
        detailTaskModel.completed = detailTaskModel.completed
        
        //Delete the old notification
        ParseController.deleteNotification(detailTaskModel)
        
        // Create the new notification
        var idString = NSUUID().UUIDString
        var notification = UILocalNotification()
        notification.alertBody = detailTaskModel.name.capitalizedString
        notification.fireDate = dueDatePicker.date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "TODO_CATEGORY"
        notification.userInfo = ["UUID": idString]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        // Update local values
        detailTaskModel.notificationUUID = idString
        detailTaskModel.pinInBackgroundWithBlock { (success, error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.mainVC.tableView.reloadData()
            self.delegate?.taskDetailEdited!()
        }
        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        mainVC.tableView.reloadData()
//        delegate?.taskDetailEdited!()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
