//
//  LandingPgVC.swift
//  DayDay
//
//  Created by Nishat Anjum on 2/26/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit
import FirebaseAuth

class LandingPgVC: UIViewController, RadialMenuDelegate {

    var radialMenu:RadialMenu!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.layer.cornerRadius = self.button.frame.size.width / 2
        self.button.clipsToBounds = true
        self.radialMenu = RadialMenu()
        self.radialMenu.delegate = self
        self.button.setBackgroundImage(self.radialMenu.getProfilePic(), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showPopup(_ sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePg") as! ProfileVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    // Logout function
    @IBAction func logout(_ sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //Radial Menu Buttons
    @IBAction func buttonPressed(_ sender: AnyObject) {
        self.radialMenu.buttonsWillAnimateFromButton(sender as! UIButton, frame: self.button.frame, view: self.view)
    }
    
    func numberOfItemsInRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 3
    }
    
    func arcSizeInRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 360
    }
    
    func arcRadiousForRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 120
    }
    
    func radialMenubuttonForIndex(_ radialMenu:RadialMenu,index:NSInteger)->RadialButton {
        
        let button:RadialButton = RadialButton()
        
        self.button.layer.cornerRadius = self.button.frame.size.width / 2;
        self.button.clipsToBounds = true;

        if index == 1 {
            button.setImage(UIImage(named: "nearMe"), for:UIControlState())
        } else if index == 2 {
            button.setImage(UIImage(named: "pastEvents"), for:UIControlState())
        }
        if index == 3 {
            button.setImage(UIImage(named: "currentEvent"), for:UIControlState())
        } 
        
        return button
    }
    
    func radialMenudidSelectItemAtIndex(_ radialMenu:RadialMenu,index:NSInteger) {
        
        /************ SEGUES NEED TO BE UPDATED AS MORE VCs ARE ADDED **************/
        /*
        let ovalStartAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180)
        let ovalRect = CGRect(x: 97.5, y: 58.5, width: 125, height: 125)
        
        let ovalPath = UIBezierPath()
        
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY),
                        radius: ovalRect.width / 2,
                        startAngle: ovalStartAngle,
                        endAngle: ovalEndAngle, clockwise: true)
        

        let progressLine = CAShapeLayer()
        progressLine.path = ovalPath.cgPath
        progressLine.strokeColor = UIColor.blue.cgColor
        progressLine.fillColor = UIColor.clear.cgColor
        progressLine.lineWidth = 10.0
        progressLine.lineCap = kCALineCapRound
        
        self.view.layer.addSublayer(progressLine)
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 3.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        progressLine.add(animateStrokeEnd, forKey: "animate stroke end animation") */
        
        if index == 1 {
            performSegue(withIdentifier: "toMap", sender: self)
        } else if index == 2 {
            performSegue(withIdentifier: "toCurrent", sender: self)
        } else if index == 3 {
           performSegue(withIdentifier: "toCurrent", sender: self)
        }
    }
    
    @IBAction func toMagic(_ sender: Any) {
        performSegue(withIdentifier: "home2magic", sender: nil)
    }
    
    @IBAction func toChannels(_ sender: Any) {
        performSegue(withIdentifier: "home2channels", sender: nil)
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue is CustomSegue {
            (segue as! CustomSegue).animationType = .GrowScale
        }
    }
    
    func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UINavigationController, identifier: String?) -> UIStoryboardSegue {
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .GrowScale
        return segue
    }
}
