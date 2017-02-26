//
//  PropertyDetailsViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/14/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit

class PropertyDetailsViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet{
            nameLabel.text = Property.selectedProperty.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
