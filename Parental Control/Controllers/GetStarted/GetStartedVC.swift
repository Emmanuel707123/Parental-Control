//
//  GetStartedVC.swift
//  Parental Control
//
//  Created by Ashish Shiroya on 26/07/2021.
//

import UIKit

class GetStartedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = UserDefaults.standard.value(forKey: "token") as? String
        {
            AppData.sharedInstance.token = token
            let RAMAnimatedTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.push(viewController: RAMAnimatedTabBarController)
        }
        else{
            if let token = UserDefaults.standard.value(forKey: "kid_token") as? String
            {
                AppData.sharedInstance.kid_token = token
                let ChildDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildDetailVC") as! ChildDetailVC
                ChildDetailVC.childCode = UserDefaults.standard.value(forKey: "childCode") as? String
                ChildDetailVC.isFrom = true
                self.navigationController?.push(viewController: ChildDetailVC)
            }
        }
    }
    
    //MARK:- btn actions
    @IBAction func btnGetStarted(_ sender: Any) {
        let SelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        self.navigationController?.push(viewController: SelectionVC)
    }
    
    @IBAction func btnHaveAccount(_ sender: Any) {
        let SelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        self.navigationController?.push(viewController: SelectionVC)
    }
}
