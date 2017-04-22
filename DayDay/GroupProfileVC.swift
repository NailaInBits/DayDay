//
//  GroupProfileVC.swift
//  DayDay
//
//  Created by Vincent Liu on 3/27/17.
//  Copyright © 2017 WePlay. All rights reserved.
//

import UIKit
import Firebase

class GroupProfileVC: UIViewController {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupDescription: UITextView!
    
    private var ref: FIRDatabaseReference!
    private var userID = FIRAuth.auth()?.currentUser?.uid
    
    var image: UIImage?
    var detail: String?
    var id: String?
    var name: String?
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fieldLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fieldLayout() {
        groupImage.image = image
        groupImage.layer.cornerRadius = 15
        groupImage.layer.borderWidth = 2.0
        groupImage.clipsToBounds = true
        
        groupDescription.text = detail
        groupDescription.clipsToBounds = true
        groupDescription.backgroundColor = UIColor.clear
        groupDescription.textAlignment = .justified
    }
    
    @IBAction func joinChat(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            
            if let value = snapshot.value as? NSDictionary {
                self.userName = value["name"] as? String
            }
        })
        
        let kpopGroupRef = ref.child("users/" + userID! + "/kpopGroups")
        
        kpopGroupRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.name!){
                
                print("Already joined")
                self.performSegue(withIdentifier: "showChat", sender: self)
                
            } else {
                
                self.ref.child("KpopGroups").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for child in value {
                            let kpopGroup = child.key
                            
                            if(kpopGroup == self.id){
                                kpopGroupRef.child(self.name!).setValue(kpopGroup)
                                self.performSegue(withIdentifier: "showChat", sender: self)
                            }
                        }
                    } else {
                        print("Error! Could not decode group data")
                    }
                })

            }
            
        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showChat" {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? ChatVC {
                    childVC.groupId = self.id!
                    childVC.senderDisplayName = self.userName!
                    self.prepareForSegue(segue: segue, sender: self)
                }
            }
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue is CustomSegue {
            (segue as! CustomSegue).animationType = .GrowScale
        }
    }
    
    
    @IBAction func closeGroup(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
