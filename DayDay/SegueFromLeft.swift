//
//  SegueFromLeft.swift
//  DayDay
//
//  Created by Nishat Anjum on 3/11/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit
import QuartzCore

class SegueFromLeft: UIStoryboardSegue {
    override func perform() {
        let toViewController = destination
        let fromViewController = source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        toViewController.view.transform = CGAffineTransform(translationX: -fromViewController.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.50,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseInOut,
                                   animations: {
                                    toViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                                   completion: { finished in
                                    let fromVC = self.source
                                    let toVC = self.destination
                                    fromVC.present(toVC, animated: false, completion: nil)
        }
        )
    }
}
