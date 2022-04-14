//
//  NotificationVC.swift
//  Parental Control
//
//  Created by Ashish Shiroya on 26/07/2021.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
        self.tblView.tableFooterView = UIView.init()
    }
}

extension NotificationVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! chatCell
        if indexPath.row == 0
        {
            cell.imgIcon.tintColor = .red
            cell.imgIcon.image = UIImage(named: "alert")
            cell.lblName.textColor = .red
            cell.lblName.text = "Harmful Content Detection: Self-Harm"
        }
        else if indexPath.row == 1
        {
            cell.imgIcon.tintColor = .black
            cell.imgIcon.image = UIImage(named: "notification-2")
            cell.lblName.textColor = .black
            cell.lblName.text = "Inappropiate message blocked from being sent to Jake."
        }
        else if indexPath.row == 2
        {
            let myMutableString = NSMutableAttributedString(string: "Blocked Photos:\nPornography Web Search", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:15))
            cell.lblName.attributedText = myMutableString
            cell.imgIcon.image = UIImage(named: "alert")
            cell.imgIcon.tintColor = .black
        }
        else{
            let myMutableString = NSMutableAttributedString(string: "Blocked Messaged:\nHeard you didn’t make the team told you you’re s***.", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:16))
            cell.lblName.attributedText = myMutableString
            cell.imgIcon.image = UIImage(named: "chatred")
            cell.imgIcon.tintColor = .red
        }
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
//        let ChildDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ChildDetailVC") as! ChildDetailVC
//        self.navigationController?.push(viewController: ChildDetailVC)
    }
}
