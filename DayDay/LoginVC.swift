//
//  LoginVC.swift
//  DayDay
//
//  Created by Nishat Anjum on 2/17/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit
import AVFoundation
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background Video (make sure always under 5mb)
        /*let videoURL: NSURL = Bundle.main.url(forResource: "bg", withExtension: "mp4")! as NSURL
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player?.seek(to: kCMTimeZero)
                self.player?.play()
            }
        })*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkForFirstTime() {
        let ref = FIRDatabase.database().reference(fromURL: "https://dayday-39e15.firebaseio.com/users")
        guard let uid = user?.uid else {
            return
        }
        ref.queryOrderedByKey().queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value == nil || snapshot.value is NSNull) {
                let usersReference = ref.child(uid)
        
                let graphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start{
                    (connection, result, err) in
        
                    if ((err) != nil) {
                        print("Error: \(err)")
                    } else {
                        print("fetched user: \(result)")
        
                        let values: [String:AnyObject] = result as! [String : AnyObject]
        
                        // update our database
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        // if there's an error in saving to our firebase database
                        if err != nil {
                            print(err)
                            return
                        }
                        // no error
                        print("Save the user successfully into Firebase database")
                        })
                    }
                }
            } else {
                return
            }
        })
    }
    
    // Facebook Login
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
        
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if ((error) != nil) {
                    print("Login error: \(error?.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    
                    self.checkForFirstTime()
                }
        
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Onboarding") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }   
    }
    
}
