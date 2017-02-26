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
import FirebaseAuth
import SwiftyJSON

class PPACtion {
    
    //TODO : avoid button be multiple pressed at once, avoid button spam
    
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
    
    func initUser(){
        
        print("USER : load USER")
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid
            else {
                print("USER : NO UID FOUND")
                return
        }
        
        print("USER : id \(uid)")
        
        frDBref.child("User").child(uid).child("type").observeSingleEvent(of: .value, with: { (snapshot) in
            if
                snapshot.exists(),
                let accountType = snapshot.value as? String
            {
                self.loadUserInfo(withType: accountType, id: uid)
                self.observeUserInfoChanged(withType: accountType, id: uid)
            }
            else
            {
                print("USER : accountType Not found / Error")
            }
            
            
        })
        
        
    }
    
    func loadUserInfo(withType type : String, id : String){
        var isChild = true
        var isAdmin = false
        switch type {
        case "PPAdmin" :
            isAdmin = true
        case "AdminAgent", "AdminDeveloper" :
            isChild = false
        case "StdDeveloper","StdAgent" :
            isChild = true
        default:
            print ("USER : USER acctTYPE not found")
            //arningPopUp(withTitle: "User", withMessage: "User not found")
            return
        }
        

        frDBref.child(type).child(id).observeSingleEvent(of: .value, with: { (snapshot) in
        //frDBref.child(type).child(id).observe(.value, with: { (snapshot) in
            if
                snapshot.exists(),
                let value = snapshot.value {
                //TODO : creat user using data
                let json = JSON(value)
                
                print("USER : Initializing User")
                if isAdmin{
                    print("USER : Initializing ADMIN USER")
                    print("TODO : add admin user right and user initializer")
                }
                else {
                    if !isChild {
                        print("USER : Initializing PARENT USER")
                        let user = ParentUser(id: id, accountType: type, json: json)
                        User.setCurrentUser(user)
                    } else {
                        print("USER : Initializing CHILD USER")
                        let user = ChildUser(id: id, accountType: type, json: json)
                        User.setCurrentUser(user)
                    }
                }
                
                if self.firstLoad {
                    self.loadUserCompletion?()
                }
                
            }else{
                print("USER : load user info Error")
            }
        })
    }

    //TODO : seperate obeser user info changed event
    func observeUserInfoChanged(withType type : String, id : String){
        frDBref.child(type).child(id).observe(.childChanged, with: { (snapshot) in
            if
                snapshot.exists(),
                let value = snapshot.value {
                print("USER : User info Changed @\(snapshot.key)")
                User.valueChange(key: snapshot.key, value: value)
            }
            else{
                print("USER : change user info Error")
            }
        })
    }
    
    var loadUserCompletion: (()->Void)?
    var firstLoad = true
    
    
    func modifyDatabase(path: String,key: String,value: String){
        frDBref.child("\(path)/\(key)").setValue(value)
    }
    
    func modifyDatabase(path: String,dictionary : [String : String]){
        frDBref.child("\(path)/").setValue(dictionary)
    }
    
    func modifyDatabaseByAutoID(path: String, dictionary : [String : String]) -> String {
        let ref = frDBref.child("\(path)/").childByAutoId()
        ref.setValue(dictionary)
        
        return ref.key
        
    }
    
    
    func generatedCode(owner : User , codeId : String, type : AccountType) {
        
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
    
    
    func preparePropertyDict(name : String) -> [String : String]{
        return [:]
    }
    
    func addProperty(owner : User , propertyName : String, floor : Int, column : Int) {
        var dict = ["owner" : owner.id, "timeGenerated" : String(Date().timeIntervalSince1970), "name" : propertyName]
        dict["floor"] = String(floor)
        dict["column"] = String(column)
        let path1 = "Property/"
        let autoID = modifyDatabaseByAutoID(path: path1, dictionary: dict)
        
        let path2 = "\(owner.type.rawValue)/\(owner.id)/property/"
        modifyDatabase(path: path2, key: autoID, value: "true")
        
        
    }
    
}



var imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}


extension UIImageView {
    
    func roundShape() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.contentMode = .scaleAspectFill
    }
    
    func centerSquare(){
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    
}

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
}



//TODO : USer protocol to creat general variable (user)

//protocol MainTabViewControllerProtocol : class {
//
//}
//
//extension MainTabViewControllerProtocol {
//    func getUser() -> ParentUser {
//        return User.testParentUser
//    }
//}
