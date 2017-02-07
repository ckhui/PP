//
//  User.swift
//  PP
//
//  Created by NEXTAcademy on 1/20/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Code {
    enum Status : String {
        case Avalable
        case Used
    }
    var id : String
    var status : Status
    var accountType : String
    var timeGenerated : TimeInterval
    var user : String
    
    init() {
        id = "none"
        status = .Used
        accountType = "none"
        timeGenerated = 0
        user = "none"
    }
    
    init(codeId : String, value :JSON) {
        id  = codeId
        
        if value["timeUsed"].stringValue == "-1" {
            status = .Avalable
        }else {
            status = .Used
        }
        
        accountType = value["accountType"].stringValue
        timeGenerated = value["timeGenerated"].doubleValue
        
        user = value["user"].stringValue
    }
    
    func isUsed() -> Bool {
        switch status {
        case .Avalable:
            return false
        case .Used :
            return true
        }
    }
    
    func type() -> String {
        switch accountType {
        case "AD" :
            return "AdminDeveloper"
        case "AA" :
            return "AdminAgent"
        case "SD" :
            return "StdDeveloper"
        case "SA" :
            return "StdAgent"
        default:
            return "none"
        }

    }
    
    func parentType() -> String {
        
        switch accountType {
        case "AD" , "AA":
            return "PPAdmin"
        case "SD" :
            return "AdminDeveloper"
        case "SA" :
            return "AdminAgent"
        default:
            return "none"
        }
    }
    
}


class ParentUser {
    
    
    
    
    enum ParentType : String{
        case Admin
        case AdminDeveloper
        case AdminAgent
        case None
    }
    
    var name : String = "ParentName"
    var id : String = "AAA"
    var details : [String:Any] = [:]
    var generatedCode : [String] = []
    var childUser : [ChildUser] = []
    var usedCode : String = "XXX"
    var type : ParentType = .None
}


class ChildUser {
    
    enum ChildType : String {
        case StdDeveloper
        case StdAgent
    }
    
    var name : String = "ChildName"
    var id : String = "AAA"
    var details : [String:Any] = [:]
    var usedCode : String = "XXX"
    var parentUser : ParentUser?
    //var property
}


class AccountInfo {
    var name : String
    var email : String
    var password : String
    var image : UIImage?
    
    init(name : String , email : String, password : String, image : UIImage?) {
        self.name = name
        self.email = email
        self.password = password
        self.image = image
    }
    
}

class User {
   
    
    static var testParentUser : ParentUser {
        let tempUser = ParentUser()
        tempUser.id = "user uid"
        tempUser.name = "testAccount"
        tempUser.type = .Admin
        
        return tempUser
        
    }
    
//    enum accountType {
//        case parent
//        case child
//        case admin
//    }
//    
//    var type : accountType
//    var child : ChildUser?
//    var parent : ParentUser?
//    
//    static let loginUser = User()
//    private init() {
//        
//    }
    
}
