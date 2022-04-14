//
//  AddChildVC.swift
//  Parental Control
//
//  Created by Ashish Shiroya on 26/07/2021.
//

import UIKit

class AddChildVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    var isFrom = false
    var imagePicker = UIImagePickerController()
    var selectedImg = UIImage()
    @IBOutlet weak var imgProfile: UIImageView!
    var profileSelect = false
    
    //MARK:- default method of ViewControllers
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Token :=> ",AppData.sharedInstance.token)
    }
    
    //MARK:- open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- open gallery
    func openGallary()
    {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        // imagePicker.mediaTypes = ["public.image"]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        //        {
        if #available(iOS 11.0, *) {
            if let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
            {
                print(fileUrl)
                
            }
            
        } else {
            // Fallback on earlier versions
        }
        self.selectedImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imgProfile.image = self.selectedImg
        self.profileSelect = true
        imagePicker.dismiss(animated: true, completion: nil)
        // }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- add post web Service
    func addChildWebService()
    {
        view.endEditing(true)
        AppData.sharedInstance.showLoader()
        
        let url = BASE_URL + ADD_CHILD
        
        let params = ["name": self.txtName.text ?? "",
                      "age": self.txtAge.text ?? ""] as NSDictionary
        
//        "app_device_id": AppData.sharedInstance.fcm_token,
        
        print("PARAM :=> \(params)")
        
        APIUtilities.sharedInstance.uploadImage(image: self.selectedImg, url: url, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            
            print(response ?? "")
            if(error == nil)
            {
                guard let res = response as? NSDictionary, let success = res.value(forKey: "success") as? Int else{
                    return
                }
                if success == 1
                {
                    self.profileSelect = false
                    if self.isFrom
                    {
                        self.navigationController?.pop()
                    }
                    else{
                        let RAMAnimatedTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.push(viewController: RAMAnimatedTabBarController)
                    }
                }
                else{
                    AppData.sharedInstance.showAlert(title: "", message: res.value(forKey: "message") as! String, viewController: self)
                }
            }
        }
    }
    
    //MARK:- check validation
    func validate() -> Bool {
        if (!AppData.sharedInstance.isValidatePresence(string: self.txtName.text!)) {
            AppData.sharedInstance.showAlert(title: "Required!", message: "Please enter name of child", viewController: self)
            return false
        }
        else if (!AppData.sharedInstance.isValidatePresence(string: self.txtAge.text!)) {
            AppData.sharedInstance.showAlert(title: "Required!", message: "Please enter child age", viewController: self)
            return false
        }
        else if !self.profileSelect
        {
            AppData.sharedInstance.showAlert(title: "Required!", message: "Please select profile of child", viewController: self)
            return false
        }
        else {
            return true
        }
    }
    
    //MARK:- btn actions
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    
    @IBAction func btnAddImg(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let take = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default) { (action) in
            self.openCamera()
        }
        let pick = UIAlertAction(title: "Pick From Gallery", style: UIAlertAction.Style.default) { (action) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        
        actionSheet.addAction(take)
        actionSheet.addAction(pick)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnCreate(_ sender: Any) {
        if validate()
        {
            self.addChildWebService()
        }
    }
}
