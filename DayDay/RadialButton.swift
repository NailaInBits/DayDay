//
//  RadialButton.swift
//  DayDay
//
//  Created by Nishat Anjum on 2/26/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit

protocol RadialButtonDelegate:class{
    
    func buttonDidFinishAnimation(_ radialButton : RadialButton)
}

class RadialButton: UIButton {
    
    weak var delegate:RadialButtonDelegate?
    var centerPoint:CGPoint!
    var bouncePoint:CGPoint!
    var originPoint:CGPoint!
    
    func willAppear () {
        
        self.imageView?.transform = CGAffineTransform.identity.rotated(by: 180/180 * CGFloat(Double.pi))
        self.alpha                = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.center               = self.bouncePoint
            self.imageView?.transform = CGAffineTransform.identity.rotated(by: 0/180 * CGFloat(Double.pi))
        }) { (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.center = self.centerPoint
            })
        }
<<<<<<< HEAD
        
=======

>>>>>>> master
        self.imageView?.layer.cornerRadius = self.imageView!.frame.width / 2
        self.imageView?.clipsToBounds = true
    }
    
    func willDisappear () {
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            if let imageView = self.imageView {
                imageView.transform = CGAffineTransform.identity.rotated(by: -180/180 * CGFloat(Double.pi))
            }
            
        })  { (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.center = self.originPoint
            }, completion: { (finished) -> Void in
                self.alpha = 0
                self.delegate?.buttonDidFinishAnimation(self)
            })
        }
    }
}

