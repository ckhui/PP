//
//  ProfileViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI


class ProfileViewController: UIViewController{

    
    //test
    var storageRef : FIRStorageReference!
    
    var user : User!
    
    
    //UI
    
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC load : Profile")
        
        storageRef = FIRStorage.storage().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // TODO : do onec after setting user
        loadProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = User.currentUser
        displayUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayUserInfo(){
        uidLabel.text = user.id
        nameLabel.text = user.name
        typeLabel.text = user.type.rawValue
        
    }
    
    func loadProfileImage(){
        let imagesRef = storageRef.child("user/ProfileImage.png")
        let placeholderImage = UIImage(named: "fan.png")
        profileImageView.sd_setImage(with: imagesRef, placeholderImage: placeholderImage)
        
    }
    
    @IBAction func logoutTapped(_ sender: AnyObject) {
        let popUP = UIAlertController(title: "log out", message: "yer or no", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
            do
            {
                try FIRAuth.auth()?.signOut()
            }
            catch let logoutError {
                print(logoutError)
            }
            self.notifySuccessLogout()
        }
        
        popUP.addAction(noButton)
        popUP.addAction(yesButton)
        present(popUP, animated: true, completion: nil)
    }
    
    func notifySuccessLogout ()
    {
        let UserLogoutNotification = Notification (name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(UserLogoutNotification)
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
