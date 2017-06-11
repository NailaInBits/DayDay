//
//  GroupProfileVC.swift
//  DayDay
//
//  Created by Vincent Liu on 3/27/17.
//  Copyright © 2017 WePlay. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GroupProfileVC: UIViewController {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupDescription: UITextView!
    
    @IBOutlet var navBar: UINavigationItem!
    
    var gradientLayer: CAGradientLayer!
    
    var groupId: String!
    var image: UIImage!
    
    private var ref: FIRDatabaseReference =
        FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createGradientLayer()
    }
    
    // Performs query to retrieve Kpop group information in Firebase
    private func groupDetail() {
        self.groupImage.image = image
        
        let groupRef = self.ref.child("KpopGroups").child(self.groupId)
        
        groupRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            // Invalid query
            if !snapshot.exists() {
                print("No group record is found")
                return
            }
            
            if let value = snapshot.value as? NSDictionary {
                self.groupDescription.text = value["description"] as! String
                self.groupDescription.clipsToBounds = true
                self.groupDescription.backgroundColor = UIColor.clear
                self.groupDescription.textAlignment = .justified
                
                self.navBar.title = value["name"] as? String
            }
        })
    }
    
    // Joins the group public chat
    @IBAction func joinChat(_ sender: Any) {
    }
    
    // Unwind button
    @IBAction func closeGroup(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // Gradient background
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.51, green:0.64, blue:0.83, alpha:1.0).cgColor, UIColor(red:0.71, green:0.98, blue:1.00, alpha:1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Ignore this
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
