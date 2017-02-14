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
        initUser()
        
        // Do any additional setup after loading the view.
        print("VC LOAD : TABBAR")
        self.selectedIndex = 2
        
        
        
        //TODO : LOAD USER INFO HERE
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        frDBref.child(type).child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if
                snapshot.exists(),
                let value = snapshot.value {
                //TODO : creat user using data
                print(value)
            }else{
                print("USER : load user info Error")
            }
        })
    }
    
    func observeUserInfoChanged(withType type : String, id : String){
        frDBref.child(type).child(id).observe(.childChanged, with: { (snapshot) in
            //code
            print(" User : Value changed -> \(snapshot)")
            if
                snapshot.exists(),
                let value = snapshot.value {
                print("hey : ")
            }
            else{
                print("USER : change user info Error")
            }
        })

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
