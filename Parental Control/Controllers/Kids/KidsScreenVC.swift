//
//  KidsScreenVC.swift
//  Parental Control
//
//  Created by mac on 02/08/21.
//

import UIKit

class KidsScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- btn actions
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.pop()
    }
}
