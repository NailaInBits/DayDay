//
//  OnboardingVC.swift
//  DayDay
//
//  Created by Nishat Anjum on 3/23/17.
//  Copyright © 2017 WePlay. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class OnboardingVC: UIViewController {
    
    var gradientLayer: CAGradientLayer!
    
    private var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("users")
    private var values = [String]()
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    private var buttonSelected: [String: Bool] = [
                                         "bts": false,
                                         "blackPink": false,
                                         "exo": false,
                                         "twice": false,
                                         "bigBang": false,
                                         "got7": false
                                         ]
    
    private var groupIDs: [String: String] = [
                          "bts": "-KgCx7qeem3u2dlMDr0i",
                          "blackPink": "-KgCx8cRgj4qca_K4aBR",
                          "exo": "-KgCx9jdmLA78msqYnV-",
                          "twice": "-KgH9pgaNoBpu_wYqV8o",
                          "bigBang": "-KgH9qIca2Wgw-Dhs4JS",
                          "got7": "-KgH9qbONq9hzFQcagPJ"
                          ]

    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var fourthButton: UIButton!
    @IBOutlet var fifthButton: UIButton!
    @IBOutlet var sixthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Button Animation:
        //This section sets the button origin outside of VC
        instructionsLabel.center.y -= view.bounds.width
        firstButton.center.x -= view.bounds.width
        thirdButton.center.x -= view.bounds.width
        fifthButton.center.x -= view.bounds.width
        secondButton.center.x += view.bounds.width
        fourthButton.center.x += view.bounds.width
        sixthButton.center.x += view.bounds.width
        
        //Gradient Background:
        createGradientLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Button Animation:
        //Animates the Instructions
        UIView.animate(withDuration: 2.0, animations: {
            self.instructionsLabel.center.y += self.view.bounds.width
        })
        
        //Animates buttons themselves
        UIView.animate(withDuration: 1.5, delay: 0.5,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [], animations: {
                        self.firstButton.center.x += self.view.bounds.width
                        self.thirdButton.center.x += self.view.bounds.width
                        self.fifthButton.center.x += self.view.bounds.width
                        self.secondButton.center.x -= self.view.bounds.width
                        self.fourthButton.center.x -= self.view.bounds.width
                        self.sixthButton.center.x -= self.view.bounds.width
        }, completion: nil)
    }
    
    // Six group buttons
    @IBAction func addGroup1(_ sender: UIButton) {
        if buttonSelected["bts"]! {
            firstButton.setBackgroundImage(#imageLiteral(resourceName: "g1"), for: UIControlState.normal)
            buttonSelected["bts"] = false
        } else {
            // Toggles when selected
            firstButton.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
            firstButton.backgroundColor = UIColor.clear
            buttonSelected["bts"] = true
        }
    }
    
    @IBAction func addGroup2(_ sender: UIButton) {
        if buttonSelected["blackPink"]! {
            secondButton.setBackgroundImage(#imageLiteral(resourceName: "g2"), for: UIControlState.normal)
            buttonSelected["blackPink"] = false
        } else {
            secondButton.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
            secondButton.backgroundColor = UIColor.clear
            buttonSelected["blackPink"] = true
        }
    }
    
    @IBAction func addGroup3(_ sender: UIButton) {
        if buttonSelected["exo"]! {
            thirdButton.setBackgroundImage(#imageLiteral(resourceName: "g3"), for: UIControlState.normal)
            buttonSelected["exo"] = false
        } else {
            thirdButton.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
            thirdButton.backgroundColor = UIColor.clear
            buttonSelected["exo"] = true
        }
    }
    
    @IBAction func addGroup4(_ sender: UIButton) {
        if buttonSelected["twice"]! {
            fourthButton.setBackgroundImage(#imageLiteral(resourceName: "g4"), for: UIControlState.normal)
            buttonSelected["twice"] = false
        } else {
            fourthButton.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
            fourthButton.backgroundColor = UIColor.clear
            buttonSelected["twice"] = true
        }
    }
    
    @IBAction func addGroup5(_ sender: UIButton) {
        if buttonSelected["bigBang"]! {
            fifthButton.setBackgroundImage(#imageLiteral(resourceName: "g5"), for: UIControlState.normal)
            buttonSelected["bigBang"] = false
        } else {
            fifthButton.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
            fifthButton.backgroundColor = UIColor.clear
            buttonSelected["bigBang"] = true
        }
    }
    
    @IBAction func addGroup6(_ sender: UIButton) {
        if buttonSelected["got7"]! {
            sixthButton.setBackgroundImage(#imageLiteral(resourceName: "g6"), for: UIControlState.normal)
            buttonSelected["got7"] = false
        } else {
            sixthButton.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
            sixthButton.backgroundColor = UIColor.clear
            buttonSelected["got7"] = true
        }
    }
    
    // Performs query to add each group values to user's record
    @IBAction func addGroups(_ sender: Any) {
        let kpopGroupRef = self.userRef.child(userID! + "/kpopGroups")
        
        for (key, value) in buttonSelected {
            if value {
                if let groupID = self.groupIDs[key] {
                    kpopGroupRef.child(key).setValue(groupID)
                }
            }
        }
        self.performSegue(withIdentifier: "showLanding", sender: UIButton.self)
    }
    
    // Skips onboarding process
    @IBAction func skipGroups(_ sender: Any) {
        self.performSegue(withIdentifier: "showLanding", sender: UIButton.self)
    }
 
    // Gradient background
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0.9804, green: 0.7882, blue: 0.4863, alpha: 1.0).cgColor,
                                UIColor(red:0.92, green:0.56, blue:0.84, alpha:1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Ignore this
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
