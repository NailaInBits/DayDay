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

class LoginVC: UIViewController, UIScrollViewDelegate {
    
    var gradientLayer: CAGradientLayer!
    var player: AVPlayer?
    var audio: AVAudioSession = AVAudioSession.sharedInstance()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
<<<<<<< HEAD
        
        textView.textAlignment = .center
        textView.text = "Rain drop, drop top, get on DayDay kpop."
        
=======

        textView.textAlignment = .center
        textView.text = "Rain drop, drop top, get on DayDay kpop."

>>>>>>> master
        // Size (in width) for the Scroll View
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        // Timer for page slide
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
        //Background Video (make sure always under 5mb)
        /*let videoURL: NSURL = Bundle.main.url(forResource: "bg", withExtension: "mp4")! as NSURL
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        do {
            try audio.setCategory(AVAudioSessionCategoryAmbient)
            try audio.setActive(true)
        } catch let error as NSError {
            print(error)
        }
        
        
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
<<<<<<< HEAD

=======
    
>>>>>>> master
    //Gradient Background:
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:1.00, green:0.73, blue:0.76, alpha:1.0).cgColor,
                                UIColor(red:0.71, green:0.84, blue:0.80, alpha:1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // First time user registration process
    func checkForFirstTime() {
        let ref = FIRDatabase.database().reference(fromURL: "https://dayday-39e15.firebaseio.com/users")
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        ref.queryOrderedByKey().queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value == nil || snapshot.value is NSNull) {
                let usersReference = ref.child(uid)
                
                _ = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start{
                    (connection, result, err) in
                    
                    if ((err) != nil) {
                        print("Error: \(String(describing: err))")
                    } else {
                        print("fetched user: \(String(describing: result))")
                        
                        let values: [String:AnyObject] = result as! [String : AnyObject]
<<<<<<< HEAD
                        
                        // Update our database
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            // If there's an error in saving to our firebase database
                            if err != nil {
                                print(err!)
                                return
                            }
                            // No error
                            print("Save the user successfully into Firebase database")
=======
        
                        // Update our database
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        // If there's an error in saving to our firebase database
                        if err != nil {
                            print(err!)
                            return
                        }
                        // No error
                        print("Save the user successfully into Firebase database")
>>>>>>> master
                        })
                        
                        // Present the onboarding view
                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Onboarding") {
                            UIApplication.shared.keyWindow?.rootViewController = viewController
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } // end Facebook public data retrieval
            } else {
                return
            }
        }) // end Firebase query
    }
    
    // Facebook Login
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        
        // Necessary logout to avoid conflict
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error != nil) {
                print("Failed to login: \(String(describing: error?.localizedDescription))")
                return
            } else if (result?.isCancelled)! {
                print("Login is cancelled")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if (error != nil) {
                    print("Login error: \(String(describing: error?.localizedDescription))")
                    let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    self.checkForFirstTime()
                }
                
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LandingPg") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            textView.text = "Chat and connect with other kpop fans."
        }else if Int(currentPage) == 1{
            textView.text = "Livestream with up and coming kpop artists and personnel."
        }else if Int(currentPage) == 2{
            textView.text = "Buy and sell your kpop merchandise."
        }else{
            textView.text = "Rain drop, drop top, get on DayDay kpop."
        }
    }
    
    
    func moveToNextPage () {
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    
    // Ignore this
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
