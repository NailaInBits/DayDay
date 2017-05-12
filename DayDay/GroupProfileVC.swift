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
    
    var groupId: String!
    var image: UIImage!
    private var ref: FIRDatabaseReference =
        FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func groupDetail() {
        self.groupImage.image = image
        
        let groupRef = self.ref.child("KpopGroups").child(self.groupId)
        
        groupRef.observe(FIRDataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            
            if let value = snapshot.value as? NSDictionary {
                self.groupDescription.text = value["description"] as! String
                self.groupDescription.clipsToBounds = true
                self.groupDescription.backgroundColor = UIColor.clear
                self.groupDescription.textAlignment = .justified
                
                self.navBar.title = value["name"] as? String
            }
        })
    }
    
    @IBAction func joinChat(_ sender: Any) {
    }
    
    
    @IBAction func closeGroup(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
