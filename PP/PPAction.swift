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
    
    
    func generatedCode(owner : ParentUser , codeId : String, type : AccountType , completion : (_ code : String) -> Void) {
        
        let dict = ["owner" : owner.id,
                    "timeGenerated" : String(Date().timeIntervalSince1970),
                    "timeUsed" : "-1",
                    "accountType" : type.rawValue,
                    "user" : "none"]
        
        let path1 = "Code/\(codeId)/"
        modifyDatabase(path: path1, dictionary: dict)
        
        let path2 = "\(owner.type.rawValue)/\(owner.id)/generatedCode/"
        modifyDatabase(path: path2, key: codeId, value: "true")
        
        
        completion(codeId)
    }
    
    
    func preparePropertyDict(name : String) -> [String : String]{
        return [:]
    }
    
    func addProperty(owner : ParentUser , propertyName : String) {
        let dict = ["owner" : owner.id, "timeGenerated" : String(Date().timeIntervalSince1970), "name" : propertyName]
        
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
