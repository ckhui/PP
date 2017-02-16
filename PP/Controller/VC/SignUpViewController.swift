//
//  SignUpViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class SignUpViewController: UIViewController,imagepickerViewControllerDelegate {
    
    
    //dolinking
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    @IBOutlet weak var cancleButton: UIButton! { didSet{
        cancleButton.addTarget(self, action: #selector(onCancelButtonTapped(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var choosePhotoButton: UIButton! { didSet{
        choosePhotoButton.addTarget(self, action: #selector(onChoosePhotoButtonPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var createButton: UIButton! { didSet{
        createButton.addTarget(self, action: #selector(onCreateUserPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var profileImagePreview: UIImageView!
    var fullProfilImage : UIImage?
    
    @IBOutlet weak var referenceCodeTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    //link
    
    var frDBref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frDBref = FIRDatabase.database().reference()
        
        //imageView.border
        profileImagePreview.layer.borderWidth = 3.0
        profileImagePreview.layer.borderColor = UIColor.blue.cgColor
    }
    
    func onCreateUserPressed(button: UIButton) {
        //check empty
        guard
            let username = usernameTextField.text ,
            let email = emailTextField.text ,
            let password = passwordTextField.text ,
            let repeatPassword = repeatPasswordTextField.text ,
            let referenceCode = referenceCodeTextField.text
            else{
                displayMessage("Cannot read data from field")
                return
        }
        
        
        let (isValid, message) = validateInput(code: referenceCode, name: username, email: email, password: password, repeatPassword: repeatPassword)
        
        if !isValid {
            displayMessage(message)
            return
        }
        
        let accountInfo = AccountInfo(name: username, email: email, password: password, image: fullProfilImage)
        
        
        //TODO: if email ald exist
        
        checkCodeExist(code: referenceCode, generateAccount: true, accountInfo: accountInfo)
        
        //go back
        //dismiss(animated: true, completion: nil)
    }
    
    
    func creatAccountSuccessfulPopUp(userName: String?,email: String?){
        let message = "Account creted with \nUsername : \(userName) \nEmail : \(email)"
        let title = "Account Successful Create"
        warningPopUp(withTitle: title, withMessage: message)
    }
    
    func onCancelButtonTapped(button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func onChoosePhotoButtonPressed(button: UIButton) {
        //        let vc = imagepickerViewController()
        //        vc.delegate = self
        //        present(vc, animated: true, completion: nil)
        
        performSegue(withIdentifier: "signInToSelectPhoto", sender: self)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInToSelectPhoto" {
            let vc : imagepickerViewController = segue.destination as! imagepickerViewController
            if let pic = profileImagePreview.image
            {
                vc.currentImage = pic
            }
            vc.delegate = self
            
        }
        return
    }
    
    //MARK: ImagepickerDelegate
    func imagepickerVCDidSelectPicture(selectedImage: UIImage) {
        fullProfilImage = selectedImage
        profileImagePreview.image = selectedImage
    }
    
    func displayMessage(_ message : String){
        messageLabel.text = message
    }
    
    
    func validateInput(code : String, name : String , email : String, password : String , repeatPassword : String) -> (Bool, String) {
        
        //check empty
        if code == "" { return (false, "Code cannot be empty") }
        if name == "" { return (false, "Name cannot be empty") }
        if email == "" { return (false, "Email cannot be empty") }
        if password == "" { return (false, "Password cannot be empty") }
        if repeatPassword == "" { return (false, "Password cannot be empty") }
        
        //TODO : more specific email and username validation, regular expression
        if password != repeatPassword { return (false, "Password not match") }
        
        return (true, "Valid Input")
        
    }
    
    
    
    
    //MARK : SignUp
    private func createAccountUsingCode(_ code : Code, accountInfo : AccountInfo){
        
        //create user / get uid
        FIRAuth.auth()?.createUser(withEmail: accountInfo.email, password: accountInfo.password) { (user, error) in
            if let createAccountError = error {
                print("AUTH : Creat Account error : \(createAccountError)")
                return
            }
            guard let currentUser = user else{
                print("AUTH : impossible current user not found error")
                return
            }
            
            let uid = currentUser.uid
            self.useCode(code, uid: uid, accountInfo: accountInfo)
            
            let message = "Account creted with \nUsername : \(accountInfo.name) \nEmail : \(accountInfo.email)"
            let title = "Account Successful Create"
            
            print("AUTH : Account creted \(accountInfo.name) & \(accountInfo.email)")
            self.warningPopUp(withTitle: title, withMessage: message)
            
            //self.creatAccountSuccessfulPopUp(userName: accountInfo.name, email: accountInfo.email)
            //avoid logged in directly after account successfully created
            try! FIRAuth.auth()!.signOut()
            //TODO: Done create user go to login page and fill the email
            
        }
        
    }
    
    private func addAccountToDatabase(uid : String, code : Code, accountInfo : AccountInfo){
        
        generateNewUserDatabase(uid: uid, withCode : code, accountInfo: accountInfo)
        
        print("AUTH : Adding profile image to databse")
        //upload profilePic to storage (if image exist)
        if accountInfo.image != nil {
            print("AUTH : User have image to upload")
            saveProfileImageToStorage(image: accountInfo.image!, uid: uid, accountType : code.type())
        }else {
            print("AUTH : User have NO image to upload")
        }
    }
    
    
    
    private func checkCodeExist(code : String , generateAccount use : Bool = false , accountInfo : AccountInfo? = nil) {
        
        print("AUTH : checking code \(code)")
        frDBref.child("Code").child(code).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                let jsonVar = JSON(snapshot.value)
                
                var newCode = Code(codeId: code, value: jsonVar)
                
                if newCode.isUsed() {
                    print("AUTH : Used Code")
                    if use {
                        print("AUTH : Cannot create account")
                    }
                } else {
                    print("AUTH : Available Code")
                    if use {
                        guard let accountInfo = accountInfo
                            else {
                                print("AUTH : Using code, account info missing")
                                return
                        }
                        self.createAccountUsingCode(newCode, accountInfo: accountInfo)
                        
                    }
                }
            }
            else{
                print("AUTH : invalide code")
            }
        })
    }
    
    func useCode(_ code : Code, uid : String , accountInfo : AccountInfo){
        
        print("AUTH : Using Code")
        let path1 = "Code/\(code.id)"
        let usedTime = Date().timeIntervalSince1970
        PPACtion().modifyDatabase(path: path1, key: "timeUsed", value: String(usedTime))
        PPACtion().modifyDatabase(path: path1, key: "user", value: uid)
        
        code.used(by: uid, at: usedTime)
        
        addChildUser(code : code)
        addAccountToDatabase(uid: uid, code : code, accountInfo: accountInfo)
    }
    
    func addChildUser(code : Code){
        print("AUTH : Creating child in parent")
        let path = "\(code.parentType())/\(code.owner)/child"
        PPACtion().modifyDatabase(path: path, dictionary: [code.user : "true"])
    }
    
    func generateNewUserDatabase(uid : String, withCode code : Code, accountInfo : AccountInfo){
        let type = code.type()
        print("AUTH : Adding account Info to databse")
        let path = "User/\(uid)"
        PPACtion().modifyDatabase(path: path, dictionary: ["type" : type])
        
        let path2 = "\(type)/\(uid)"
        var tempDict = [String : String]()
        tempDict["name"] = accountInfo.name
        tempDict["email"] = accountInfo.email
        tempDict["usedCode"] = code.id
        tempDict["parent"] = code.owner
        tempDict["timeCreated"] = code.owner
        PPACtion().modifyDatabase(path: path2, dictionary: tempDict)
    }
    
    
    private func saveProfileImageToStorage(image : UIImage, uid : String, accountType : String) {
        
        print("AUTH : Preparing Image Data")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            warningPopUp(withTitle: "Image Type Error", withMessage: "Image Type Error")
            return
        }
        
        //TODO : save png file
        let newMetadata = FIRStorageMetadata()
        newMetadata.contentType = "image/jpeg"
        
        let path = "/User/\(uid).jpg"
        
        print("AUTH : Start upload image")
        //upload image
        let frStorage = FIRStorage.storage().reference()
        frStorage.child(path).put(imageData, metadata: newMetadata, completion: {
            (storageMeta, error) in
            if let uploadError = error
            {
                self.warningPopUp(withTitle: "Upload Photo Error", withMessage: "\(uploadError)")
                //this is to debug only
                //assertionFailure("Failed to upload")    // dont do this on production
                return
            }
            else {
                print("AUTH : Profile image Upload Complete")
                
                let downloadURL = storageMeta!.downloadURL()?.absoluteString
                let path = "\(accountType)/\(uid)"
                PPACtion().modifyDatabase(path: path, key: "profile", value: downloadURL!)
                
                print("AUTH : Profile image update database")
            }
        })
        
        //TODO : access image usign path, but not url
    }
    
    
    
}


