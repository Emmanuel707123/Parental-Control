//
//  ChildDetailVC.swift
//  Parental Control
//
//  Created by mac on 27/07/21.
//

import UIKit
import GTProgressBar
import SDWebImage

class ChildDetailVC: UIViewController {

    var isFrom = false
    var childCode : String?
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var progress1: GTProgressBar!
    @IBOutlet weak var progress2: GTProgressBar!
    @IBOutlet weak var progress3: GTProgressBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isFrom
        {
            self.btnBack.isHidden = true
            self.btnLogout.isHidden = false
        }
        else{
            self.btnBack.isHidden = false
        }
        
        self.getChildWebService()
        
    }
    @IBOutlet weak var btnBack: UIButton!
    
    func jsonToString(json: AnyObject)->String{
        do {
            let data1 = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let convertedString =  String(data: data1, encoding: .utf8)
            return convertedString ?? ""
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
    
    //MARK:- child listing web Service
    func getChildWebService()
    {
        view.endEditing(true)
        AppData.sharedInstance.showLoader()
    
        let url = BASE_URL + GET_SINGLE_CHILD + "\(childCode ?? "")"
        
        let type = (AppData.sharedInstance.token == "") ? "child" : "parent"
        
        let params = ["deviceToken": UIDevice.current.identifierForVendor?.uuidString ?? "",
                      "type":type] as NSDictionary
        
        APIUtilities.sharedInstance.POSTAPICallWithURLSession(url: url,param: jsonToString(json: params)) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            
            print(response ?? "")
            if(error == nil)
            {
                guard let res = response as? NSDictionary, let success = res.value(forKey: "success") as? Int else{
                    return
                }
                if success == 1
                {
                    if let data = res.value(forKey: "data") as? NSDictionary
                    {
                        DispatchQueue.main.async {
                            if let _id = data.value(forKey: "_id") as? String
                            {
                                self.getEmotionWebService(childId: _id)
                            }
                            
                            self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            
                            if let profileimage = data.value(forKey: "profileImage") as? String
                            {
                                self.imgProfile.sd_setImage(with: URL(string: profileimage), placeholderImage: UIImage(named: "placeholder_user"))
                            }
                            
                            self.lblName.text = "\(data.value(forKey: "name") as? String ?? "")'s Profile"
                        }
                        
                    }
                }
                else{
                    AppData.sharedInstance.showAlert(title: "", message: res.value(forKey: "message") as! String, viewController: self)
                }
            }
        }
    }
    
    //MARK:- child listing web Service
    func getEmotionWebService(childId : String)
    {
        view.endEditing(true)
        let url = BASE_URL + GET_EMOTION + "\(childId)"
        print(url)
        APIUtilities.sharedInstance.GetAPICallWith(url: url) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            
            print(response ?? "")
            if(error == nil)
            {
                guard let res = response as? NSDictionary, let success = res.value(forKey: "success") as? Int else{
                    return
                }
                if success == 1
                {
                    if let data = res.value(forKey: "data") as? NSDictionary
                    {
                        if data.count == 0
                        {
                            self.progress1.animateTo(progress: 0.0)
                            self.progress2.animateTo(progress: 0.0)
                            self.progress3.animateTo(progress: 0.0)
                        }
                        else{
                            self.progress1.animateTo(progress: CGFloat((data.value(forKey: "0") as! NSString).integerValue)/100)
                            self.progress2.animateTo(progress: CGFloat((data.value(forKey: "1") as! NSString).integerValue)/100)
                            self.progress3.animateTo(progress: CGFloat((data.value(forKey: "2") as! NSString).integerValue)/100)
                        }
                        
                    }
                }
                else{
                    AppData.sharedInstance.showAlert(title: "", message: res.value(forKey: "message") as! String, viewController: self)
                }
            }
        }
    }
    
    //MARK:- btn actions
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.pop()
    }
    @IBAction func btnLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "kid_token")
        AppData.sharedInstance.token = ""
        AppData.sharedInstance.kid_token = ""
        let GetStartedVC = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedVC") as! GetStartedVC
        self.navigationController?.push(viewController: GetStartedVC)
    }
}
