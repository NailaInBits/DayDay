//
//  RadialMenu.swift
//  DayDay
//
//  Created by Nishat Anjum on 2/26/17.
//  Copyright © 2017 DayDay. All rights reserved.
//
import UIKit
import FirebaseAuth

var user = FIRAuth.auth()?.currentUser

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


@objc protocol RadialMenuDelegate:class {
    func numberOfItemsInRadialMenu (_ radialMenu:RadialMenu)->NSInteger
    func arcSizeInRadialMenu (_ radialMenu:RadialMenu)->NSInteger
    func arcRadiousForRadialMenu (_ radialMenu:RadialMenu)->NSInteger
    func radialMenubuttonForIndex(_ radialMenu:RadialMenu,index:NSInteger)->RadialButton
    func radialMenudidSelectItemAtIndex(_ radialMenu:RadialMenu,index:NSInteger)
    
    @objc optional  func arcStartForRadialMenu (_ radialMenu:RadialMenu)->NSInteger
    @objc optional  func buttonSizeForRadialMenu (_ radialMenu:RadialMenu)->CGFloat
}

class RadialMenu: UIView,RadialButtonDelegate{
    var items:[UIView]! = []
    var animationTimer:Timer?
    weak var delegate:RadialMenuDelegate?
    var itemIndex:NSInteger = 0
    
    func itemsWillAppear(_ fromButton:UIButton,frame:CGRect,inView:UIView){
        
        if self.items?.count > 0 {
            return
        }
        
        if self.animationTimer != nil {
            return
        }
        
        let itemCount:NSInteger = delegate?.numberOfItemsInRadialMenu(self) ?? -1
        
        if itemCount == -1 {
            return
        }
        
        var mutablePopup:[UIView]    = []
        let arc:NSInteger            = self.delegate?.arcSizeInRadialMenu(self) ?? 90
        let radius:NSInteger         = self.delegate?.arcRadiousForRadialMenu(self) ?? 80
        var start:NSInteger          = 0
        
        if let respondArcStartMethod = self.delegate?.arcStartForRadialMenu {
            start          = respondArcStartMethod(self)
        }
        
        var  angle:CGFloat = 0
        
        if arc>=360 {
            angle         = CGFloat(-180)/CGFloat(itemCount)
        } else if itemCount>1 {
            angle         = CGFloat(arc)/CGFloat((itemCount-1))
        }
        
        let centerX       = frame.origin.x + (frame.size.height/1.6);
        let centerY       = frame.origin.y + (frame.size.width/2);
        let origin        = CGPoint(x: centerX, y: centerY);
        
        var buttonSize:CGFloat = 80.0;
        
        if let respondbuttonSizeForRadialMenuMethod = self.delegate?.buttonSizeForRadialMenu {
            buttonSize         = respondbuttonSizeForRadialMenuMethod(self)
        }
        
        var currentItem:NSInteger = 1;
        var popupButton:RadialButton?;
        
        while currentItem <= itemCount {
            
            let radians = (angle * (CGFloat(currentItem) - 2.0) + CGFloat(start)) * (CGFloat(M_PI)/CGFloat(180))
            
            let x      = round (centerX + CGFloat(radius) * cos(CGFloat(radians)));
            let y      = round (centerY + CGFloat(radius) * sin(CGFloat(radians)));
            let extraX = round (centerX + (CGFloat(radius)*1.07) * cos(CGFloat(radians)));
            let extraY = round (centerY + (CGFloat(radius)*1.07) * sin(CGFloat(radians)));
            
            let popupButtonframe = CGRect(x: centerX-buttonSize*0.5, y: centerY-buttonSize*0.5, width: buttonSize, height: buttonSize);
            let final   = CGPoint(x: x, y: y);
            let bounce  = CGPoint(x: extraX, y: extraY);
            popupButton = self.delegate?.radialMenubuttonForIndex(self, index: currentItem)
            popupButton?.frame = popupButtonframe
            popupButton?.centerPoint = final
            popupButton?.bouncePoint = bounce
            popupButton?.originPoint = origin
            popupButton?.tag         = currentItem
            popupButton?.delegate    = self
            popupButton?.addTarget(self, action: #selector(RadialMenu.buttonPressed(_:)), for: UIControlEvents.touchUpInside)
            popupButton.map {inView.insertSubview($0, belowSubview: fromButton)}
            popupButton.map { mutablePopup.append($0)}
            currentItem += 1
        }
        
        self.items     = mutablePopup;
        self.itemIndex = 0;
        let maxDuration:CGFloat = 0.50;
        let flingInterval       = maxDuration/CGFloat(self.items.count);
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(RadialMenu.willFlingItem), userInfo: nil, repeats: true)
        let spinDuration        = CGFloat(self.items.count+1) * flingInterval;
        self.shouldRotateButton(fromButton, forDuration: spinDuration, forwardDirection: false)
    }
    
    func itemsWillDisapearIntoButton(_ button:UIButton) {
        
        if self.items?.count == 0 {
            return
        }
        
        if let animation =  self.animationTimer  {
            animation.invalidate()
            self.animationTimer = nil
            self.itemIndex      = self.items.count
        }
        
        let maxDuration:CGFloat = 0.50
        let flingInterval       = maxDuration / CGFloat(self.items.count)
        self.animationTimer     = Timer.scheduledTimer(timeInterval: Double(flingInterval), target: self, selector: #selector(RadialMenu.willRecoilItem), userInfo: nil, repeats: true)
        let spinDuration        = CGFloat(self.items.count + 1) * flingInterval
        self.shouldRotateButton(button, forDuration: spinDuration, forwardDirection: false)
    }
    
    func buttonsWillAnimateFromButton(_ sender:AnyObject,frame:CGRect,view:UIView) {
        
        if self.animationTimer != nil {
            return
        }
        if self.items?.count > 0 {
            self.itemsWillDisapearIntoButton(sender as! UIButton)
        } else {
            self.itemsWillAppear(sender as! UIButton, frame: frame, inView: view)
        }
    }
    
    func shouldRotateButton(_ button:UIButton,forDuration:CGFloat, forwardDirection:Bool) {
        
       /* let spinAnimation            = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.duration       = Double(forDuration)
        spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        var totalDuration            = 1.5 * CGFloat(self.items.count)
        
        if forwardDirection {
            
            totalDuration = totalDuration * -1
        }
        spinAnimation.toValue = NSNumber(value: Float(totalDuration) as Float)
        button.layer.add(spinAnimation, forKey: "spinAnimation")*/
        //Lol message here
        
         
         let spinAnimation            = CABasicAnimation(keyPath: "transform.scale")
         //spinAnimation.fromValue = Int(1.5)
         //spinAnimation.toValue = Int(1.0)
         spinAnimation.duration       = 0.5 //Double(forDuration)
         spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
         var totalDuration            = 0.5 * CGFloat(self.items.count) //CGFloat(M_PI)
         
         if forwardDirection {
         
         totalDuration = totalDuration * -1
         }
         spinAnimation.toValue = NSNumber(value: Float(totalDuration) as Float)
         button.layer.add(spinAnimation, forKey: "spinAnimation")
 
     /*   let popAnimation            = CABasicAnimation(keyPath: "transform.scale")
        popAnimation.fromValue = Int(1.5)
        popAnimation.toValue = Int(1.0)
        
        popAnimation.duration = 0.5
        popAnimation.isRemovedOnCompletion = false
        popAnimation.fillMode = kCAFillModeForwards
        popAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //popAnimation.toValue = NSNumber(value: Float(forDuration) as Float)
        button.layer.add(popAnimation, forKey: "scale") */
        
    }
    
    @objc func willRecoilItem() {
        
        if self.itemIndex == 0 {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
            return;
        }
        self.itemIndex -= 1
        
        let button = self.items[self.itemIndex] as! RadialButton
        button.willDisappear()
    }
    
    @objc func willFlingItem() {
        
        if self.itemIndex == self.items.count {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
            return;
        }
        
        let button = self.items[self.itemIndex] as! RadialButton
        button.willAppear()
        self.itemIndex += 1
    }
    
    func buttonPressed(_ sender:AnyObject) {
        
        let button = sender as! RadialButton
        
        self.delegate?.radialMenudidSelectItemAtIndex(self, index: button.tag)
    }
    
    func buttonDidFinishAnimation(_ radialButton : RadialButton) {
        
        radialButton.removeFromSuperview()
        
        if radialButton.tag == 1 {
            self.items = nil
        }
    }
    
    func getProfilePic() -> UIImage? {
        
        let imgURLString = "https://graph.facebook.com/" + "621159167" + "/picture?type=large"
        let imgURL = URL(string: imgURLString)
        
        do {
            let imageData = try Data(contentsOf: imgURL!)
            let image = UIImage(data: imageData)
            return image
        } catch {
            return nil
        }
    }
}


