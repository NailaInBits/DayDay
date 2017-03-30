//
//  SideMenuVC.swift
//  DayDay
//
//  Created by Vincent Liu on 3/26/17.
//  Copyright © 2017 WePlay. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var ref: FIRDatabaseReference =
                     FIRDatabase.database().reference().child("KpopGroups")
    private var group = [String]()
    
    var interactor:Interactor? = nil
    var groupImages: [UIImage] = [UIImage.init(imageLiteralResourceName: "1"),
                                  UIImage.init(imageLiteralResourceName: "2"),
                                  UIImage.init(imageLiteralResourceName: "3"),
                                  UIImage.init(imageLiteralResourceName: "4"),
                                  UIImage.init(imageLiteralResourceName: "5"),
                                  UIImage.init(imageLiteralResourceName: "6")]
    
    @IBOutlet weak var groupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveGroupDetail()
        groupTableView.backgroundColor = UIColor.clear
        groupTableView.rowHeight = groupTableView.frame.size.height / 5.23
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGroupDetail" {
            if let navControler = segue.destination as? UINavigationController {
                if let childVC = navControler.topViewController as? GroupProfileVC {
                    childVC.image = self.groupImages[(groupTableView.indexPathForSelectedRow?.section)!]
                    childVC.detail = self.group[(groupTableView.indexPathForSelectedRow?.section)!]
                }
            }
        }
    }
    
    private func retrieveGroupDetail() {
        self.ref.observe(.childAdded, with: { (snapshot) -> Void in
            let groupData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = groupData["name"] as! String!, name.characters.count > 0 {
                self.group.append(groupData["description"] as! String)
            } else {
                print("Error! Could not decode group data")
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupImages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        imageView.image = self.groupImages[(indexPath as NSIndexPath).section]
        
        cell.backgroundColor = UIColor.clear
        cell.backgroundView = UIImageView(image: imageView.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.26, green:0.81, blue:0.64, alpha:1.0)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 5
        
        return cellSpacingHeight
    }
    

    // Side Menu pan gesture dismiss interaction
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(
            translationInView: translation,
            viewBounds: view.bounds,
            direction: .Left
        )
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
        
                self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func closeSideMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
