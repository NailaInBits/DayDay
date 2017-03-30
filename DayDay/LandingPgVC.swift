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

    let interactor = Interactor()
    
    var radialMenu:RadialMenu!
    var gradientLayer: CAGradientLayer!
    
    private var ref: FIRDatabaseReference!
    private var userID = FIRAuth.auth()?.currentUser?.uid
    private var fid: String?
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet var sideMenuEdgePan: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.layer.cornerRadius = self.button.frame.size.width / 2
        self.button.clipsToBounds = true
        self.radialMenu = RadialMenu()
        self.radialMenu.delegate = self
        self.retrieveUserInfo()
        //self.button.setBackgroundImage(self.getProfilePicture(), for: UIControlState.normal)
        sideMenuEdgePan.edges = .left
        view.addGestureRecognizer(sideMenuEdgePan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
<<<<<<< HEAD
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createGradientLayer()
    }
    
=======
    private func retrieveUserInfo() {
        
        self.ref = FIRDatabase.database().reference()
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.exists() { return }
            
            if let value = snapshot.value as? NSDictionary {
                self.fid = value["id"] as? String
            }
        })
    }
    
    private func getProfilePicture() -> UIImage? {
        
        let imgURLString = "https://graph.facebook.com/" + self.fid! + "/picture?type=large"
        let imgURL = URL(string: imgURLString)
        
        do {
            let imageData = try Data(contentsOf: imgURL!)
            let image = UIImage(data: imageData)
            return image
        } catch {
            return nil
        }
    }
    
    // Side Menu button
    @IBAction func openSideMenu(_ sender: AnyObject) {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SideMenuVC {
            destinationViewController.transitioningDelegate = self
            
            destinationViewController.interactor = interactor
        }
    }
    
    // Profile page button
>>>>>>> 83d381e6b2256082401f79668c68f8e31fda0d37
    @IBAction func showPopup(_ sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfilePg") as! ProfileVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    //Radial Menu Buttons
    @IBAction func buttonPressed(_ sender: AnyObject) {
        self.radialMenu.buttonsWillAnimateFromButton(sender as! UIButton, frame: self.button.frame, view: self.view)
    }
    
    func numberOfItemsInRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 3
    }
    
    func arcSizeInRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 360
    }
    
    func arcRadiousForRadialMenu (_ radialMenu:RadialMenu)->NSInteger {
        return 120
    }
    
    func radialMenubuttonForIndex(_ radialMenu:RadialMenu,index:NSInteger)->RadialButton {
        
        let button:RadialButton = RadialButton()
        
        self.button.layer.cornerRadius = self.button.frame.size.width / 2;
        self.button.clipsToBounds = true;

        //Add in child image url
        if index == 1 {
            button.setImage(UIImage(named: "nearMe"), for:UIControlState())
        } else if index == 2 {
            button.setImage(UIImage(named: "pastEvents"), for:UIControlState())
        }
        if index == 3 {
            button.setImage(UIImage(named: "currentEvent"), for:UIControlState())
        } 
        
        return button
    }
    
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
        
        if index == 1 {
            performSegue(withIdentifier: "toMap", sender: self)
        } else if index == 2 {
            performSegue(withIdentifier: "toCurrent", sender: self)
        } else if index == 3 {
           performSegue(withIdentifier: "toCurrent", sender: self)
        }
    }
    
    @IBAction func toMagic(_ sender: Any) {
        performSegue(withIdentifier: "home2magic", sender: nil)
    }
    
    @IBAction func toChannels(_ sender: Any) {
        performSegue(withIdentifier: "home2channels", sender: nil)
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue is CustomSegue {
            (segue as! CustomSegue).animationType = .GrowScale
        }
    }
    
    func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UINavigationController, identifier: String?) -> UIStoryboardSegue {
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .GrowScale
        return segue
    }
    
<<<<<<< HEAD
    //Gradient Background
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.67, green:0.43, blue:1.00, alpha:1.0).cgColor, UIColor(red:0.46, green:0.73, blue:0.96, alpha:1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
=======
}

// Adds the presentation animation to Transitioning delegate
extension LandingPgVC: UIViewControllerTransitioningDelegate {
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
>>>>>>> 83d381e6b2256082401f79668c68f8e31fda0d37
    }
}
