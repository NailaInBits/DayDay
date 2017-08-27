//
//  GroupProfileVC.swift
//  DayDay
//
//  Created by Vincent Liu on 3/27/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

class GroupProfileVC: UIViewController {
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupDescription: UITextView!
    
    var image: UIImage?
    var detail: String?
    var groupName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fieldLayout() {
        groupImage.image = image
        groupImage.clipsToBounds = true
        
        groupDescription.text = detail
        groupDescription.clipsToBounds = true
        groupDescription.backgroundColor = UIColor.clear
        groupDescription.textAlignment = .justified
        
        self.navigationItem.title = groupName!
    }
    
    @IBAction func joinChat(_ sender: Any) {
    }
    
    
    @IBAction func closeGroup(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
