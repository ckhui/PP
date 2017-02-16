//
//  User.swift
//  PP
//
//  Created by NEXTAcademy on 1/20/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import Foundation
import SwiftyJSON

class Code {
    enum Status : String {
        case Avalable
        case Used
    }
    var id : String
    var status : Status
    var accountType : String
    var timeGenerated : TimeInterval
    var timeUsed : TimeInterval
    var user : String
    var owner : String
    
    init() {
        id = "none"
        status = .Used
        accountType = "none"
        timeGenerated = 0
        timeUsed = 0
        user = "none"
        owner = "none"
    }
    
    init(codeId : String, value :JSON) {
        id  = codeId
        
        if value["timeUsed"].stringValue == "-1" {
            status = .Avalable
        }else {
            status = .Used
        }
        
        timeUsed = value["timeUsed"].doubleValue
        
        accountType = value["accountType"].stringValue
        timeGenerated = value["timeGenerated"].doubleValue
        
        user = value["user"].stringValue
        
        owner = value["owner"].stringValue
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
    
    func used(by uid : String , at time : TimeInterval){
        user = uid
        timeUsed = time
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

class PPHelper {
    static func getUserTypeFrom(string : String) -> AccountType{
        switch string {
        case "AdminDeveloper" :
            return .AdminDeveloper
        case "AdminAgent" :
            return .AdminAgent
        case "StdDeveloper" :
            return .StdDeveloper
        case "StdAgent" :
            return .StdAgent
        default :
            return .None
        }
    }
}

class ParentUser {
    
    var id : String = "AAA"
    var name : String = "ParentName"
    var email : String = "Email"
    var imageUrl : String?
    var generatedTime : String = ""
    var usedCode : String = "XXX"
    var type : AccountType = .None
    
    var generatedCode : [String] = []
    var childUser : [ChildUser]?
    
    
    init(id : String, accountType : String, json : JSON){
        
        self.id = id
        
        name = json["name"].stringValue
        email = json["email"].stringValue
        imageUrl = json["profile"].string
        
        generatedTime = json["timeCreated"].stringValue
        usedCode = json["usedCode"].stringValue

        type = PPHelper.getUserTypeFrom(string: accountType)

        //generatedCode
        //childUser

    }
}


class ChildUser {
    
    var id : String = "AAA"
    var name : String = "ChildName"
    var email : String = "Email"
    var imageUrl : String?
    var generatedTime : String = ""
    var usedCode : String = "XXX"
    var type : AccountType = .None
    
    var parentUserID : String?
    
    //var property
    
    init(id : String, accountType : String, json : JSON){
        
        self.id = id
        
        name = json["name"].stringValue
        email = json["email"].stringValue
        imageUrl = json["profile"].string
        
        generatedTime = json["timeCreated"].stringValue
        usedCode = json["usedCode"].stringValue
        
        type = PPHelper.getUserTypeFrom(string: accountType)
        
        parentUserID = json["parent"].stringValue
        
    }
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
   
    var isParent = false
    
    var id : String = "Default User"
    var name : String = "User Name"
    var email : String = "Email"
    var type : AccountType = .None
    var imageUrl : String?
    var generatedTime : String = ""
    var usedCode : String = "Code"
    
    var childUser : [ChildUser]?
    var parentUserID : String?
    
    static var currentUser = User()
    
    init() {}
    
    init(_ parent : ParentUser) {
        isParent = true
        
        id = parent.id
        name = parent.name
        email = parent.email
        type = parent.type
        imageUrl = parent.imageUrl
        generatedTime = parent.generatedTime
        usedCode = parent.usedCode

        childUser = parent.childUser


    }
    
    init(_ child : ChildUser){
        isParent = false
        
        id = child.id
        name = child.name
        email = child.email
        type = child.type
        imageUrl = child.imageUrl
        generatedTime = child.generatedTime
        usedCode = child.usedCode
        
        parentUserID = child.parentUserID
    }
    
    /*
    init(id : String, type : String json : JSON) {
        
        self.id = id
        
        self.type = type
        
        
        name = json["name"].stringValue
        email = json["email"].stringValue
        
        details = child.details
        usedCode = child.usedCode
 
        childUser = parent.childUser
 
        parentUserID = child.parentUserID
        
        print(json)
        
        print("done")
    }
     */
    
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
