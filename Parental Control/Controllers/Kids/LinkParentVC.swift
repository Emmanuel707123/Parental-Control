//
//  LinkParentVC.swift
//  Parental Control
//
//  Created by mac on 02/08/21.
//

import UIKit

class LinkParentVC: UIViewController {

    @IBOutlet weak var txtCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    func childLoginingWebService()
    {
        view.endEditing(true)
        AppData.sharedInstance.showLoader()
    
        let url = BASE_URL + GET_SINGLE_CHILD + "\(self.txtCode.text ?? "")"
        
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
                    if let response = res.value(forKey: "data") as? NSDictionary
                    {
                        if let token = response.value(forKey: "token") as? String
                        {
                            UserDefaults.standard.setValue(token, forKey: "kid_token")
                            AppData.sharedInstance.kid_token = token
                        }
                        AppData.sharedInstance.child_code = response.value(forKey: "childCode") as! String
                        UserDefaults.standard.setValue(AppData.sharedInstance.child_code, forKey: "childCode")
                        DispatchQueue.main.async {
                            let ChildDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildDetailVC") as! ChildDetailVC
                            ChildDetailVC.childCode = AppData.sharedInstance.child_code
                            ChildDetailVC.isFrom = true
                            self.navigationController?.push(viewController: ChildDetailVC)
                        }
                        
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
        if (!AppData.sharedInstance.isValidatePresence(string: self.txtCode.text!)) {
            AppData.sharedInstance.showAlert(title: "Required!", message: "Please enter child code", viewController: self)
            return false
        }
        else {
            return true
        }
    }
    
    //MARK:- btn actions
    @IBAction func btnDone(_ sender: Any) {
        if self.validate()
        {
            self.childLoginingWebService()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.pop()
    }

}
