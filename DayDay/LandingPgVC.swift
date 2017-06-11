//
//  LandingPgVC.swift
//  DayDay
//
//  Created by Nishat Anjum on 2/26/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LandingPgVC: UIViewController, RadialMenuDelegate {
<<<<<<< HEAD
    
    // SIDE MENU
    let interactor = Interactor()
    @IBOutlet var sideMenuEdgePan: UIScreenEdgePanGestureRecognizer!
=======

    // SIDE MENU STUFF T.T
    
    //let interactor = Interactor()
    //@IBOutlet var sideMenuEdgePan: UIScreenEdgePanGestureRecognizer!
>>>>>>> master
    
    var radialMenu:RadialMenu!
    var gradientLayer: CAGradientLayer!
    
    private var groupId: String?
    private var groupImage: UIImage?
    
    private var ref: FIRDatabaseReference!
    private var userID = FIRAuth.auth()?.currentUser?.uid
    private var fid: String? // Facebook ID
    private var userName: String?
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
<<<<<<< HEAD
    @IBOutlet weak var button: UIButton!
    
=======
>>>>>>> master
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Radial menu button properties
        self.button.layer.cornerRadius = self.button.frame.size.width / 2
        self.button.clipsToBounds = true
        
        self.radialMenu = RadialMenu()
        self.radialMenu.delegate = self
        
        self.retrieveUserInfo()
        
<<<<<<< HEAD
        // SIDE MENU
        sideMenuEdgePan.edges = .left
        view.addGestureRecognizer(sideMenuEdgePan)
=======
        // SIDE MENU STUFF T.T
        
        //sideMenuEdgePan.edges = .left
        //view.addGestureRecognizer(sideMenuEdgePan)
>>>>>>> master
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createGradientLayer()
    }
    
    // Performs query to retrieve user record in Firebase
    private func retrieveUserInfo() {
        
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("users").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
            
            // Invalid query
            if !snapshot.exists() {
                print("No user record is found")
                return
            }
            
            if let value = snapshot.value as? NSDictionary {
                self.fid = value["id"] as? String
                self.userName = value["name"] as? String
                
                // Tints the radial menu image
                let tint = UIColor(red:0.23, green:0.38, blue:0.53, alpha:0.2)
                self.button.setBackgroundImage(self.getProfilePicture(fid: self.fid)?.tintedImage(with: tint), for: UIControlState.normal)
            }
        }) // end query
    }
    
    // Facebook graph API call to retrieve user's FB Profile Picture
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
            }
        }
        
        return nil
    }
    
    // SIDE MENU STUFF T.T
    
    // Side Menu button
    /* @IBAction func openSideMenu(_ sender: AnyObject) {
        performSegue(withIdentifier: "SideMenu", sender: nil)
    }
    
    // Side Menu pan gesture present interaction
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(
            translationInView: translation,
            viewBounds: view.bounds,
            direction: .Right
        )
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                performSegue(withIdentifier: "SideMenu", sender: nil)
        }
    } */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // SIDE MENU STUFF T.T
        
        /* if segue.identifier == "SideMenu" {
            if let destinationViewController = segue.destination as? SideMenuVC {
                destinationViewController.transitioningDelegate = self
                destinationViewController.interactor = interactor
            }
        } */
        
        /* if segue.identifier == "showChat" {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? ChatVC {
                    childVC.groupId = self.groupId!
                    childVC.senderDisplayName = self.userName!
                    self.prepareForSegue(segue: segue, sender: self)
                }
            }
        } */
        
        if segue.identifier == "showGroup" {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? GroupProfileVC {
                    // Provides group ID and group image to the GroupProfileVC
                    childVC.groupId = self.groupId!
                    childVC.image = self.groupImage!
                    
                    self.prepareForSegue(segue: segue, sender: self)
                }
            }
        }
    }
    
    // Profile page button
    @IBAction func showPopup(_ sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePg") as! ProfileVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    // Radial Menu Buttons
    @IBAction func buttonPressed(_ sender: AnyObject) {
        self.radialMenu.buttonsWillAnimateFromButton(sender as! UIButton, frame: self.button.frame, view: self.view)
    }
    
    func numberOfItemsInRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 6
    }
    
    func arcSizeInRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 360
    }
    
    func arcRadiousForRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 120
    }
    
    func radialMenubuttonForIndex(_ radialMenu:RadialMenu,index:NSInteger)->RadialButton {
        let button:RadialButton = RadialButton()
<<<<<<< HEAD
        
=======

>>>>>>> master
        //Add in child image url
        if index == 1 {
            button.setImage(UIImage(named: "g1"), for:UIControlState())
        } else if index == 2 {
            button.setImage(UIImage(named: "g2"), for:UIControlState())
        } else if index == 3 {
            button.setImage(UIImage(named: "g3"), for:UIControlState())
        } else if index == 4 {
            button.setImage(UIImage(named: "g4"), for:UIControlState())
        } else if index == 5 {
            button.setImage(UIImage(named: "g5"), for:UIControlState())
        } else if index == 6 {
            button.setImage(UIImage(named: "g6"), for:UIControlState())
        }
        
        return button
    }
    
    // When radial button is selected, prepares group ID and image for segue
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
        
        /*if index == 1 {
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 2 {
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 3 {
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 4 {
         performSegue(withIdentifier: "showChat", sender: self)
         } else if index == 5 {
         performSegue(withIdentifier: "showChat", sender: self)
         } else if index == 6 {
         performSegue(withIdentifier: "showChat", sender: self)
         } */
        
        if index == 1 {
            self.groupId = "-KgCx7qeem3u2dlMDr0i"
            self.groupImage = UIImage(named: "g1")
<<<<<<< HEAD
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 2 {
            self.groupId = "-KgCx8cRgj4qca_K4aBR"
            self.groupImage = UIImage(named: "g2")
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 3 {
            self.groupId = "-KgCx9jdmLA78msqYnV-"
            self.groupImage = UIImage(named: "g3")
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 4 {
            self.groupId = "-KgH9pgaNoBpu_wYqV8o"
            self.groupImage = UIImage(named: "g4")
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 5 {
            self.groupId = "-KgH9qIca2Wgw-Dhs4JS"
            self.groupImage = UIImage(named: "g5")
            performSegue(withIdentifier: "showChat", sender: self)
        } else if index == 6 {
            self.groupId = "-KgH9qbONq9hzFQcagPJ"
            self.groupImage = UIImage(named: "g6")
            performSegue(withIdentifier: "showChat", sender: self)
=======
            performSegue(withIdentifier: "showGroup", sender: self)
        } else if index == 2 {
            self.groupId = "-KgCx8cRgj4qca_K4aBR"
            self.groupImage = UIImage(named: "g2")
            performSegue(withIdentifier: "showGroup", sender: self)
        } else if index == 3 {
            self.groupId = "-KgCx9jdmLA78msqYnV-"
            self.groupImage = UIImage(named: "g3")
            performSegue(withIdentifier: "showGroup", sender: self)
        } else if index == 4 {
            self.groupId = "-KgH9pgaNoBpu_wYqV8o"
            self.groupImage = UIImage(named: "g4")
            performSegue(withIdentifier: "showGroup", sender: self)
        } else if index == 5 {
            self.groupId = "-KgH9qIca2Wgw-Dhs4JS"
            self.groupImage = UIImage(named: "g5")
            performSegue(withIdentifier: "showGroup", sender: self)
        } else if index == 6 {
            self.groupId = "-KgH9qbONq9hzFQcagPJ"
            self.groupImage = UIImage(named: "g6")
            performSegue(withIdentifier: "showGroup", sender: self)
>>>>>>> master
        }
    }
    
    /*@IBAction func toMagic(_ sender: Any) {
     performSegue(withIdentifier: "home2magic", sender: nil)
     } */
    
    // Custom segue animation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue is CustomSegue {
            (segue as! CustomSegue).animationType = .GrowScale
        }
    }
    
    // Custom segue unwind animation
    func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UINavigationController, identifier: String?) -> UIStoryboardSegue {
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .GrowScale
        return segue
    }
    
    // Gradient Background
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.67, green:0.43, blue:1.00, alpha:1.0).cgColor, UIColor(red:0.46, green:0.73, blue:0.96, alpha:1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Ignore this
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// SIDE MENU STUFF T.T

// Adds the presentation animation to Transitioning delegate
/* extension LandingPgVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
} */

extension UIImage {
    // Tint an image with specified color
    func tintedImage(with tintColor: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        // draw black background - workaround to preserve color of partially transparent pixels
        context?.setBlendMode(.normal)
        UIColor.black.setFill()
        context?.fill(rect)
        
        // draw original image
        context?.setBlendMode(.normal)
        context?.draw(self.cgImage!, in: rect)
        
        // draw tint color, preserving alpha values of original image
        context?.setBlendMode(.color)
        tintColor.setFill()
        context?.fill(rect)
        
        // mask by alpha values of original iamge
        context?.setBlendMode(.destinationIn)
        context?.draw(self.cgImage!, in: rect)
        
        let coloredImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage!
    }
}
