//
//  BuildingBlockCollectionViewCell.swift
//  PP
//
//  Created by CKH on 09/03/2017.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit

class BuildingBlockCollectionViewCell: UICollectionViewCell {

    
    static let identifireTop = "TopBuildingBlock"
    static let identifireLeft = "LeftBuildingBlock"
    static let identifire = "BuildingBlock"
    static let cellNib = UINib(nibName: "BuildingBlockCollectionViewCell", bundle: Bundle.main)
    
    @IBOutlet weak var label: UILabel! {
        didSet{
            label.textAlignment = .left
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
