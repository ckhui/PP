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

class PPMainTabBarController: UITabBarController {

    var frDBref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frDBref = FIRDatabase.database().reference()

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
        guard let uid = FIRAuth.auth()?.currentUser?.uid
        else {
         print("USER : NO UID FOUND")
        }
        
        //frDBref.child("User").child(uid)
        
        
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
