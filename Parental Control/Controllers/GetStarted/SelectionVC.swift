//
//  SelectionVC.swift
//  Parental Control
//
//  Created by mac on 28/07/21.
//

import UIKit

class SelectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnParent(_ sender: Any) {
        let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.push(viewController: LoginVC)
    }
    
    @IBAction func btnKids(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        AppData.sharedInstance.token = ""
        let LinkParentVC = self.storyboard?.instantiateViewController(withIdentifier: "LinkParentVC") as! LinkParentVC
        self.navigationController?.push(viewController: LinkParentVC)
    }
}
