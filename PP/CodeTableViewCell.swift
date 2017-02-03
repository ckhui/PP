//
//  CodeTableViewCell.swift
//  PP
//
//  Created by NEXTAcademy on 2/2/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit

class CodeTableViewCell: UITableViewCell {

    
    var code = Code()
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var parentLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayCodeInfo() {
        print("Code print :  \(code) " )
        codeLabel.text = code.id
        typeLabel.text = code.accountType
        nameLabel.text = code.status.rawValue
        parentLabel.text = code.parentType()
        uidLabel.text = code.user
        
        
    }
    
    

}
