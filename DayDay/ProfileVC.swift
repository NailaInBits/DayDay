//
//  ProfileVC.swift
//  DayDay
//
//  Created by Vincent Liu on 3/9/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class ProfileVC: UIViewController {
    
    private var ref: FIRDatabaseReference!
    private var userID = FIRAuth.auth()?.currentUser?.uid
    private var fid: String?
    
    var editTextFieldToggle: Bool = false
    
    @IBOutlet weak var ProfilePageView: UIView!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Username: UITextField!
    
    // Username text field writability toggle
    @IBAction func textFieldToggle(_ Sender: AnyObject) {
        editTextFieldToggle = !editTextFieldToggle
        
        if editTextFieldToggle == true {
            Username.isUserInteractionEnabled = true
            Username.becomeFirstResponder()
            Username.selectedTextRange = Username.textRange(from: Username.beginningOfDocument, to: Username.endOfDocument)
            Username.backgroundColor = UIColor.white
        } else {
            self.updateUsername()
            Username.isUserInteractionEnabled = false
            Username.backgroundColor = UIColor.clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveUserInfo()
        
        fieldLayout()
        
        showAnimate()
        
        // Creates white opacity
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    // Layout of the text fields and image
    func fieldLayout() {
        ProfilePic.layer.cornerRadius = ProfilePic.frame.width / 2
        ProfilePic.layer.borderWidth = 3.0
        ProfilePic.clipsToBounds = true
        
        Email.layer.cornerRadius = 15.0
        Email.layer.borderWidth = 2.0
        Email.clipsToBounds = true
        
        Username.layer.cornerRadius = 15.0
        Username.layer.borderWidth = 2.0
        Username.clipsToBounds = true
    }
    
    // Performs a query to update username in Firebase
    private func updateUsername() {
        
        self.ref = FIRDatabase.database().reference().child("users").child(userID!)
        
        self.ref.updateChildValues(["name": self.Username.text!])
        
    }
    
    // Performs a query to retrieve user record in Firebase
    private func retrieveUserInfo() {
        
        self.ref = FIRDatabase.database().reference()
        self.ref.child("users").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            
            // Invalid query
            if !snapshot.exists() { return }
            
            if let value = snapshot.value as? NSDictionary {
                self.Email.text = value["email"] as? String
                self.Username.text = value["name"] as? String
                self.fid = value["id"] as? String
                
                self.ProfilePic.image = self.getProfilePicture(fid: self.fid)
            }
        })
    }
    
    // Facebook graph API call to retrieve user's FB profile picture
    private func getProfilePicture(fid: String?) -> UIImage? {
        
        if let uid = fid {
            let imgURLString = "https://graph.facebook.com/" + uid + "/picture?type=large"
            let imgURL = URL(string: imgURLString)
            
            do {
                let imageData = try Data(contentsOf: imgURL!)
                let image = UIImage(data: imageData)
                return image
            } catch {
                return nil
            } // End catch
        }
        
        return nil
    }
    
    // Exits profile page
    @IBAction func closePopup(_ Sender: AnyObject) {
        self.removeAnimate()
        
    }
    
    // Fade in zoom animation
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Fade out zoom animation
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
    
    // Ignore this
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
