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
    
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    private var kpopGroupsRefHandle: FIRDatabaseHandle?
    private var kpopGroups: [KpopGroup] = []
    
    private lazy var kpopGroupsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("KpopGroups")
    
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var fourthButton: UIButton!
    @IBOutlet var fifthButton: UIButton!
    @IBOutlet var sixthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeGroups()
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
    
    @IBAction func addGroup1(_ sender: UIButton) {
        let name = "BTS"
        let newKpopGroupRef = kpopGroupsRef.childByAutoId()
        let kpopGroupItem = [
            "KPop Group": name
        ]
        newKpopGroupRef.setValue(kpopGroupItem)
    }
    
    @IBAction func addGroup2(_ sender: UIButton) {
        let name = "Black Pink"
        let newKpopGroupRef = kpopGroupsRef.childByAutoId()
        let kpopGroupItem = [
            "KPop Group": name
        ]
        newKpopGroupRef.setValue(kpopGroupItem)
    }
    
    @IBAction func addGroup3(_ sender: UIButton) {
        let name = "EXO"
        let newKpopGroupRef = kpopGroupsRef.childByAutoId()
        let kpopGroupItem = [
            "KPop Group": name
        ]
        newKpopGroupRef.setValue(kpopGroupItem)
    }
    
    @IBAction func addGroup4(_ sender: UIButton) {
        let name = "Twice"
        let newKpopGroupRef = kpopGroupsRef.childByAutoId()
        let kpopGroupItem = [
            "KPop Group": name
        ]
        newKpopGroupRef.setValue(kpopGroupItem)
    }
    
    @IBAction func addGroup5(_ sender: UIButton) {
        let name = "Big Bang"
        let newKpopGroupRef = kpopGroupsRef.childByAutoId()
        let kpopGroupItem = [
            "KPop Group": name
        ]
        newKpopGroupRef.setValue(kpopGroupItem)
    }
    
    @IBAction func addGroup6(_ sender: UIButton) {
        let name = "GOT7"
        let newKpopGroupRef = kpopGroupsRef.childByAutoId()
        let kpopGroupItem = [
            "KPop Group": name
        ]
        newKpopGroupRef.setValue(kpopGroupItem)
    }
    
    private func observeGroups() {
        
        /* When the user presses a button, that kpop group needs to
         be added to an array associated with their user id */
        kpopGroupsRefHandle = kpopGroupsRef.observe(.childAdded, with: { (snapshot) -> Void in
            let kpopGroupsData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = kpopGroupsData["name"] as! String!, name.characters.count > 0 {
                self.kpopGroups.append(KpopGroup(id: id, name: name))
            } else {
                print("Error! Could not add kpop group to user id")
            }
        })
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0.9804, green: 0.7882, blue: 0.4863, alpha: 1.0).cgColor, UIColor(red:0.92, green:0.56, blue:0.84, alpha:1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

  /*func addGroups() {
 
     let key = ref.child("KPopGroups").childByAutoId().key
     
     let kpopGroupsArray = [ "name" : addGroups!.name! ]
     
     var kpopGroups = [String: AnyObject]()
     
     for (index, element) in hide.vertices.enumerate() {
     kpopGroupsArray[String(index)] =  HiddenLatlng(lat: element.latitude, lng: element.longitude).toDictionery()
     }
     
     kpopGroups["eventLatLngList"] = kpopGroupsArray as AnyObject?
     
     //Takes user id and adds a group to the kpopgroups array to id.
     self.ref.child("users").child(userID!).child("kpopGroup").updateChildValues(kpopGroups) { (error: NSError?, reference: FIRDatabaseReference) in
     Collection(error)
     }
     } */
