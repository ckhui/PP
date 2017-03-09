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

    var storageRef : FIRStorageReference!

    var user : User! {
        didSet{
            initButton(isParent: user.isParent)
            displayUserInfo()
        }
    }
    
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    
    
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
    
    func initButton(isParent parent : Bool){
        if parent {
            codeButton.isHidden = false
            codeButton.addTarget(self, action: #selector(showCodePage), for: .touchUpInside)
            
            childButton.setTitle("child", for: .normal)
            childButton.addTarget(self, action: #selector(showChildPage), for: .touchUpInside)
        } else {
            codeButton.isHidden = true
            
            childButton.setTitle("parent", for: .normal)
            childButton.addTarget(self, action: #selector(showParentPage), for: .touchUpInside)
        }
        
        feedbackButton.addTarget(self, action: #selector(showFeedbackPage), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = User.currentUser
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
        
        func notifySuccessLogout ()
        {
            let UserLogoutNotification = Notification (name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(UserLogoutNotification)
        }
        
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
            notifySuccessLogout()
        }
        
        popUP.addAction(noButton)
        popUP.addAction(yesButton)
        present(popUP, animated: true, completion: nil)
        
        
    }
    
    func showCodePage() {
        performSegue(withIdentifier: "showCode", sender: self)
    }
    
    func showChildPage() {
        performSegue(withIdentifier: "showChild", sender: self)
    }
    
    func showParentPage() {
        performSegue(withIdentifier: "showParent", sender: self)
    }
    
    func showFeedbackPage() {
        performSegue(withIdentifier: "showFeedback", sender: self)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier
            else { return }
        
        switch identifier {
        case "showCode":
            break;
        case "showChild":
            break;
        case "showParent":
            break;
        case "showFeesback":
            break
        default :
            break
        }
    }
 

}
