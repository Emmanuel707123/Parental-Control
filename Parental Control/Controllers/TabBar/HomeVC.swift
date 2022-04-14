//
//  HomeVC.swift
//  Parental Control
//
//  Created by Ashish Shiroya on 26/07/2021.
//

import UIKit
import SDWebImage
	
class homeCell : UITableViewCell
{
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblChildCode: UILabel!
    override class func awakeFromNib() {
        
    }
}

class HomeVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var arrChilds = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.childListingWebService()
    }
    
    //MARK:- child listing web Service
    func childListingWebService()
    {
        view.endEditing(true)
        AppData.sharedInstance.showLoader()
        
        let url = BASE_URL + CHILD_LISTING
        
        let params = [:] as AnyObject
        
//        "app_device_id": AppData.sharedInstance.fcm_token,
        
        print("PARAM :=> \(params)")
        
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
                    if let childs = res.value(forKey: "data") as? NSArray
                    {
                        self.arrChilds = NSMutableArray()
                        for child in childs
                        {
                            self.arrChilds.add(child)
                        }
                        self.tblView.delegate = self
                        self.tblView.dataSource = self
                        self.tblView.reloadData()
                        self.tblView.tableFooterView = UIView.init()
                    }
                }
                else{
                    AppData.sharedInstance.showAlert(title: "", message: res.value(forKey: "message") as! String, viewController: self)
                }
            }
        }
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "kid_token")
        AppData.sharedInstance.token = ""
        AppData.sharedInstance.kid_token = ""
        let GetStartedVC = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedVC") as! GetStartedVC
        self.navigationController?.push(viewController: GetStartedVC)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let AddChildVC = self.storyboard?.instantiateViewController(withIdentifier: "AddChildVC") as! AddChildVC
        AddChildVC.isFrom = true
        self.navigationController?.push(viewController: AddChildVC)
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChilds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeCell
        let model = self.arrChilds[indexPath.row] as! NSDictionary
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        if let profileimage = model.value(forKey: "profileImage") as? String
        {
            cell.imgProfile.sd_setImage(with: URL(string: profileimage), placeholderImage: UIImage(named: "placeholder_user"))
        }
        
        cell.lblName.text = model.value(forKey: "name") as? String
        cell.lblAge.text = (model.value(forKey: "age") as? NSNumber)?.stringValue
        cell.lblChildCode.text = model.value(forKey: "childCode") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.35,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.arrChilds[indexPath.row] as! NSDictionary
        let ChildDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildDetailVC") as! ChildDetailVC
        ChildDetailVC.childCode = (model.value(forKey: "childCode") as? String)!
        self.navigationController?.push(viewController: ChildDetailVC)
    }
}
