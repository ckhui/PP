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

enum AccountType : String {
    case AdminDeveloper
    case AdminAgent
    case StdDeveloper
    case StdAgent
    case Admin
    case None
}


class ParentUser {
    
    var name : String = "ParentName"
    var id : String = "AAA"
    var details : [String:Any] = [:]
    var generatedCode : [String] = []
    var childUser : [ChildUser]?
    var usedCode : String = "XXX"
    var type : AccountType = .None
}


class ChildUser {
    
    var name : String = "ChildName"
    var id : String = "AAA"
    var details : [String:Any] = [:]
    var usedCode : String = "XXX"
    var parentUserID : String?
    var type : AccountType = .None
    
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
   
    var id : String = "Default User"
    var name : String = "User Name"
    var type : AccountType = .None
    var details : [String:Any] = [:]
    var usedCode : String = "Code"
    
    var childUser : [ChildUser]?
    var parentUserID : String?
    
    static var currentUser = User()
    
    init() {}
    
    init(_ parent : ParentUser) {
        id = parent.id
        name = parent.name
        type = parent.type
        details = parent.details
        usedCode = parent.usedCode

        childUser = parent.childUser


    }
    
    init(_ child : ChildUser){
        id = child.id
        name = child.name
        type = child.type
        details = child.details
        usedCode = child.usedCode
        
        parentUserID = child.parentUserID
    }
    
    func setCurrentUser (_ parent : ParentUser){
        User.currentUser = User(parent)
    }
    
    func setCurrentUser (_ child : ChildUser){
        User.currentUser = User(child)
    }
    
    
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


class Property {
    var name : String
    var id : String
    
    init(name : String, id : String){
        self.name = name
        self.id = id
    }
}
