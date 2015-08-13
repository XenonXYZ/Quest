//
//  CustomSegue.swift
//  TaskIt
//
//  Created by Kiran Kunigiri on 8/9/15.
//  Copyright (c) 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import QuartzCore

class CustomSegue: UIStoryboardSegue {
   
    override func perform() {
//        var srcViewController = self.sourceViewController as! ViewController
//        var destViewController = self.destinationViewController as! UIViewController
//        
//        var transition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        srcViewController.view.window?.layer.addAnimation(transition, forKey: nil)
//        
//        srcViewController.presentViewController(destViewController, animated: false, completion: nil)
        
        var sourceViewController: UIViewController = self.sourceViewController as! ViewController
        var destinationViewController: UIViewController = self.destinationViewController as! UIViewController
        
        sourceViewController.view.addSubview(destinationViewController.view)
        
        var width = sourceViewController.view.frame.size.width
        destinationViewController.view.transform = CGAffineTransformMakeTranslation(width, 0)
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            
            destinationViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }) { (finished) -> Void in
                
                sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
//                destinationViewController.view.removeFromSuperview()
        }
    }
}