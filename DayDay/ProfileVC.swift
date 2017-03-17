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
    
    var ref: FIRDatabaseReference!
    var editTextFieldToggle: Bool = false
    
    @IBOutlet weak var ProfilePageView: UIView!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Username: UITextField!
    
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
        self.fieldLayout()
        
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fieldLayout() {
        self.ProfilePic.image = self.getProfilePic()
        self.ProfilePic.layer.cornerRadius = self.ProfilePic.frame.width / 2
        self.ProfilePic.layer.borderWidth = 3.0
        self.ProfilePic.clipsToBounds = true
        
        self.Email.layer.cornerRadius = 15.0
        self.Email.layer.borderWidth = 2.0
        self.Email.clipsToBounds = true
        
        self.Username.layer.cornerRadius = 15.0
        self.Username.layer.borderWidth = 2.0
        self.Username.clipsToBounds = true
    }
    
    func updateUsername() {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref = FIRDatabase.database().reference().child("users").child(userID!)
        
        ref.updateChildValues(["name": self.Username.text!])

    }
    
    func retrieveUserInfo() {
        
        ref = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            
            if let value = snapshot.value as? NSDictionary {
                self.Email.text = value["email"] as? String
                self.Username.text = value["name"] as? String
            }
            
        })
        
        /* if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                providerId = profile.providerID
                fid = profile.uid
                name = profile.displayName!
                email = profile.email!
                photoURL = profile.photoURL!
                
                Email.text = email
                Username.text = name
            }
        }*/
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
    
    @IBAction func closePopup(_ Sender: AnyObject) {
        self.removeAnimate()
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
