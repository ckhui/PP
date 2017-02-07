//
//  ProfileViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit

import FirebaseStorage
import FirebaseStorageUI


class ProfileViewController: UIViewController {

    
    //test

    var storageRef : FIRStorageReference!
    
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = FIRStorage.storage().reference()
        loadProfileImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProfileImage(){
        let imagesRef = storageRef.child("user/ProfileImage.png")
        let placeholderImage = UIImage(named: "fan.png")
        profileImageView.sd_setImage(with: imagesRef, placeholderImage: placeholderImage)
        
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
