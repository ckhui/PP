//
//  PPMainTabBarController.swift
//  PP
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class PPMainTabBarController: UITabBarController {
    
    var frDBref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frDBref = FIRDatabase.database().reference()
        //initUser()
        
        // Do any additional setup after loading the view.
        print("VC LOAD : TABBAR")
        self.selectedIndex = 2
        
        
        
        //TODO : LOAD USER INFO HERE
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func initUser(){
//        
//        print("USER : load USER")
//        
//        guard let uid = FIRAuth.auth()?.currentUser?.uid
//            else {
//                print("USER : NO UID FOUND")
//                return
//        }
//        
//        print("USER : id \(uid)")
//        
//        frDBref.child("User").child(uid).child("type").observeSingleEvent(of: .value, with: { (snapshot) in
//            if
//                snapshot.exists(),
//                let accountType = snapshot.value as? String
//            {
//                self.loadUserInfo(withType: accountType, id: uid)
//                self.observeUserInfoChanged(withType: accountType, id: uid)
//            }
//            else
//            {
//                print("USER : accountType Not found / Error")
//            }
//            
//            
//        })
//        
//        
//    }
//    
//    func loadUserInfo(withType type : String, id : String){
//        var isChild = true
//        var isAdmin = false
//        switch type {
//        case "PPAdmin" :
//            isAdmin = true
//        case "AdminAgent", "AdminDeveloper" :
//            isChild = false
//        case "StdDeveloper","StdAgent" :
//            isChild = true
//        default:
//            print ("USER : USER acctTYPE not found")
//            warningPopUp(withTitle: "User", withMessage: "User not found")
//            return
//        }
//        
//        
//        frDBref.child(type).child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//            if
//                snapshot.exists(),
//                let value = snapshot.value {
//                //TODO : creat user using data
//                let json = JSON(value)
//                
//                print("USER : Initializing User")
//                if isAdmin{
//                    print("USER : Initializing ADMIN USER")
//                    print("TODO : add admin user right and user initializer")
//                }
//                else {
//                    if !isChild {
//                        print("USER : Initializing PARENT USER")
//                        let user = ParentUser(id: id, accountType: type, json: json)
//                        User.setCurrentUser(user)
//                    } else {
//                        print("USER : Initializing CHILD USER")
//                        let user = ChildUser(id: id, accountType: type, json: json)
//                        User.setCurrentUser(user)
//                    }
//                }
//                
//            }else{
//                print("USER : load user info Error")
//            }
//        })
//    }
//    
//    func observeUserInfoChanged(withType type : String, id : String){
//        frDBref.child(type).child(id).observe(.childChanged, with: { (snapshot) in
//            //code
//            print(" User : Value changed -> \(snapshot)")
//            if
//                snapshot.exists(),
//                let value = snapshot.value {
//                print("hey : ")
//            }
//            else{
//                print("USER : change user info Error")
//            }
//        })
//        
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
