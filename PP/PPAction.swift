//
//  PPAction.swift
//  PP
//
//  Created by NEXTAcademy on 1/25/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftyJSON

class PPACtion {
    
    
    enum AccountType : String{
        case AD
        case SD
        case AA
        case SA
    }
    
    var frDBref: FIRDatabaseReference!
    init(){
        frDBref = FIRDatabase.database().reference()
    }
    
    
    func modifyDatabase(path: String,key: String,value: String){
        frDBref.child("\(path)/\(key)").setValue(value)
    }
    
    func modifyDatabase(path: String,dictionary : [String : String] , autoId : Bool = false){
        if autoId{
            frDBref.child("\(path)/").childByAutoId().setValue(dictionary)
        }
        else{
            frDBref.child("\(path)/").setValue(dictionary)
        }
    }
    
    
    
    func generatedCode(owner : ParentUser , codeId : String, type : AccountType){
        
        let dict = ["owner" : owner.id,
                    "timeGenerated" : String(Date().timeIntervalSince1970),
                    "timeUsed" : "-1",
                    "accountType" : type.rawValue,
                    "user" : "none"]
        
        let path1 = "Code/\(codeId)/"
        modifyDatabase(path: path1, dictionary: dict)
        
        let path2 = "\(owner.type.rawValue)/\(owner.id)/generatedCode/"
        modifyDatabase(path: path2, key: codeId, value: "true")
        
    }
    
    
}
