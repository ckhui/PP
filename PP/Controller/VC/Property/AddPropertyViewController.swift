//
//  PropertyListViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit


class AddPropertyViewController: UIViewController {

    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var columnTextField: UITextField!
    
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
        
        guard
            let floorInput = floorTextField.text,
            let columnInput = columnTextField.text,
            let floor = Int(floorInput),
            let column = Int(columnInput)
        else {
            warningPopUp(withTitle: "input Error", withMessage: "floor and unit must be int")
            return
        }

        PPACtion().addProperty(owner: User.currentUser, propertyName: text, floor: floor, column: column)
        
        warningPopUp(withTitle: "Property Added", withMessage: "name : \(text) \nlayout: \(floor) Floor X \(column) units")
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
