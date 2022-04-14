//
//  ChatVC.swift
//  Parental Control
//
//  Created by Ashish Shiroya on 26/07/2021.
//

import UIKit

class chatCell : UITableViewCell
{
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override class func awakeFromNib() {
        
    }
}

class ChatVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
        self.tblView.tableFooterView = UIView.init()
    }
}

extension ChatVC : UITableViewDelegate, UITableViewDataSource
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
            cell.imgIcon.tintColor = .red
            cell.imgIcon.image = UIImage(named: "chatred")
            let myMutableString = NSMutableAttributedString(string: "Blocked Messaged:\nYou are so ugly go f*** k*** y*******.", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:16))
                // set label Attribute
            cell.lblName.attributedText = myMutableString
        }
        else if indexPath.row == 2
        {
            let myMutableString = NSMutableAttributedString(string: "Blocked Photos:\nPornography Web Search", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 15.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:15))
            cell.lblName.attributedText = myMutableString
            cell.imgIcon.image = UIImage(named: "alert")
            cell.imgIcon.tintColor = .black
        }
        else
        {
            cell.imgIcon.tintColor = .black
            cell.lblName.textColor = .black
            cell.imgIcon.image = UIImage(named: "chatred")
            cell.lblName.text = "Location Check-in:\nGot on the bus safely."
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
