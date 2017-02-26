//
//  PropertyListViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit


class AddPropertyViewController: UIViewController {

    @IBOutlet weak var propertylist: UILabel! {
        didSet{
            propertylist.text = ""
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet{
            textField.backgroundColor = UIColor.lightGray
        }
    }

    @IBAction func addPressed(_ sender: Any) {
        guard let text =  textField.text
            else { return }
        if text == "" {
            warningPopUp(withTitle: "input error", withMessage: "cannot be empty")
            return
        }
        PPACtion().addProperty(owner: User.currentUser, propertyName: text)
        
        textField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC load : Add Property")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
