//
//  GroupProfileVC.swift
//  DayDay
//
//  Created by Vincent Liu on 3/27/17.
//  Copyright © 2017 WePlay. All rights reserved.
//

import UIKit

class GroupProfileVC: UIViewController {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupDescription: UITextView!
    
    var image: UIImage?
    var detail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fieldLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    
    @IBAction func closeGroup(_ sender: AnyObject) {
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
