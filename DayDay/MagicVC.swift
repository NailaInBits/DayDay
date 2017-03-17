//
//  MagicVC.swift
//  DayDay
//
//  Created by Nishat Anjum on 3/6/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreMedia

class MagicVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var directions: UILabel!
    @IBOutlet var filterPicker: UIPickerView!
    @IBOutlet var imageView: UIImageView!
    
    var filterTitleList: [String]!
    var filterNameList: [String]!
    var selctedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.filterTitleList = ["* Choose Filter *",
                                "Blur",
                                "Pixellate",
                                "Comic Effect",
                                "Vignette",
                                "Vintage Warm Colors",
                                "Black & White",
                                "Vintage Distortion",
                                "Vintage",
                                "Vintage Fade",
                                "Saturate",
                                "Desaturate",
                                "Highlight Shadow Adjust",
                                "Depth Of Field"]
        
        self.filterNameList = ["No Filter",
                               "CIDiscBlur",
                               "CIPixellate",
                               "CIComicEffect",
                               "CIVignette",
                               "CIPhotoEffectTransfer",
                               "CIPhotoEffectTonal",
                               "CIPhotoEffectInstant",
                               "CIPhotoEffectFade",
                               "CIPhotoEffectChrome",
                               "CIVibrance",
                               "CIColorClamp",
                               "CIHighlightShadowAdjust",
                               "CIDepthOfField"]
        
        self.filterPicker.delegate = self
        self.filterPicker.dataSource = self
        self.filterPicker.isUserInteractionEnabled = false
        self.directions.isHidden = false
        self.saveButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func camAction(_ sender: AnyObject) {
        self.showImageSourceActionSheet()
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        self.saveImageToPhotoGallery()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selctedImage = newImage
            self.imageView.image = self.selctedImage
            self.filterPicker.isUserInteractionEnabled = true
            self.directions.isHidden = true
            self.saveButton.isEnabled = false
            self.filterPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.filterTitleList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.filterTitleList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.saveButton.isEnabled = false
        } else {
            self.saveButton.isEnabled = true
        }
    
        self.applyFilter(selectedFilterIndex: row)
    }
    
    fileprivate func showImageSourceActionSheet() {
        let alertCtrl = UIAlertController(title: "Select Image Source" , message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let galleryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertActionStyle.default, handler: {
            (alertAction) -> Void in
            self.showPhotoGallery()
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {
            (alertAction) -> Void in
            self.showCamera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertCtrl.addAction(galleryAction)
        alertCtrl.addAction(cameraAction)
        alertCtrl.addAction(cancelAction)
        
        alertCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = alertCtrl.popoverPresentationController
        popover?.barButtonItem = self.cameraButton
        
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    fileprivate func showPhotoGallery() -> Void {
        print("Choose - Photo Gallery")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = imagePicker.popoverPresentationController
            popover!.barButtonItem = self.cameraButton
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlertMessage(alertTitle: "Not Supported", alertMessage: "Device can not access gallery.")
        }
    }
    
    fileprivate func showCamera() -> Void {
        print("Choose - Camera")
        
        if( UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            let imagePicker = UIImagePickerController()
        
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
            imagePicker.allowsEditing = false
            
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = imagePicker.popoverPresentationController
            popover!.barButtonItem = self.cameraButton
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }else {
            self.showAlertMessage(alertTitle: "Not Supported", alertMessage: "Camera not supported in emulator.")
        }
        
    }
    
    fileprivate func applyFilter(selectedFilterIndex filterIndex: Int) {
        if filterIndex == 0 {
            self.imageView.image = self.selctedImage
            return
        }
        
        //guard let sourceImage = CIImage(image: self.selctedImage) else { return }
        guard let sourceImage = self.imageView.image?.cgImage else { return }
        
        let myFilter = CIFilter(name: self.filterNameList[filterIndex])
        myFilter?.setDefaults()
        
        let ciImage = CIImage(cgImage: sourceImage)
        //let ciImage = CIImage(cgImage: sourceImage, scale:sourceImage.scale, orientation: sourceImage.imageOrientation)

        myFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let context = CIContext(options: nil)
        
        /*
        This is where the image rotates 45 degrees??????
        *************************************************/
        let outputCGImage = context.createCGImage(myFilter!.outputImage!, from: myFilter!.outputImage!.extent)
        //UIImage(cgImage: outputCGImage!, scale: 1.0, orientation: UIImageOrientation.right)
        //outputCGImage.imageOrientation

        /* Possible bug: createCGImage rotates the image (that's an iOS bug) and I 
            used right to correct it but it may flip good images :/ */
        let filteredImage = UIImage(cgImage: outputCGImage!, scale: 1.0, orientation: UIImageOrientation.right) //UIImage(cgImage: outputCGImage!)
        self.imageView.image = filteredImage
    }
    
    fileprivate func saveImageToPhotoGallery() {
        DispatchQueue.main.async {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(MagicVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            self.showAlertMessage(alertTitle: "Success", alertMessage: "Image Saved To Photo Gallery")
        } else {
            self.showAlertMessage(alertTitle: "Error!", alertMessage: (error?.localizedDescription)! )
        }
    }
    
    func showAlertMessage(alertTitle: String, alertMessage: String) {
        let myAlertVC = UIAlertController( title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlertVC.addAction(okAction)
        self.present(myAlertVC, animated: true, completion: nil)
    }
    
}
