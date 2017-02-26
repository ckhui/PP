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
    
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet{
            if let floor = Property.selectedProperty.floor,
                let column = Property.selectedProperty.column{
                detailsLabel.text = "Floor : \(floor) \nColumn : \(column)"
            }else{
                detailsLabel.text = "ERRO reading property data"
            }
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
