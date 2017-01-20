//
//  User.swift
//  PP
//
//  Created by NEXTAcademy on 1/20/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import Foundation


struct Code {
    enum Status {
        case Avalable
        case Used
    }
    var str : String
    var status : Status
}

class ParentUser {
    
    enum ParentType : String{
        case Admin
        case Developer
        case Agent
        case None
    }
    
    var name : String = "ParentName"
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
    var details : [String:Any] = [:]
    var usedCode : String = "XXX"
    var parentUser : ParentUser?
    //var property
}
