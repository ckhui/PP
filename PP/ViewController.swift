//
//  ViewController.swift
//  PP
//
//  Created by Students on 1/10/17.
//  Copyright © 2017 NEXT. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var uids = [String]()
    var testUser = User.testParentUser
    
    
    @IBOutlet weak var codeTableView: UITableView! {
        didSet{
            codeTableView.dataSource = self
            codeTableView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initGenerateCodeButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBOutlet weak var generateCode1: UIButton!
    @IBOutlet weak var generateCode2: UIButton!
    
    
    func initGenerateCodeButton(){
        generateCode1.isEnabled = false
        generateCode2.isEnabled = false
        let user = testUser
        if let user = user as? ParentUser {
            switch (user.type) {
            case .Admin :
                setGenerateCodeButtonFunction(button: generateCode1, codeType: .AA)
                setGenerateCodeButtonFunction(button: generateCode2, codeType: .AD)
            case .AdminAgent :
                setGenerateCodeButtonFunction(button: generateCode1, codeType: .SA)
            case .AdminDeveloper :
                setGenerateCodeButtonFunction(button: generateCode1, codeType: .SD)
            default :
                generateCode1.isEnabled = false
                generateCode2.isEnabled = false
            }
        }
    }
    
    
    func setGenerateCodeButtonFunction(button : UIButton, codeType : PPACtion.AccountType) {
        
        button.isEnabled = true
        
        button.setTitle("Gen \(codeType.rawValue) Code", for: .normal)
        button.accessibilityIdentifier = codeType.rawValue
        button.addTarget(self, action: #selector(generateCodeButtonPressed(_:)), for: .touchUpInside)
    }
    
    func generateCodeButtonPressed(_ sender : UIButton) {
        guard let type = sender.accessibilityIdentifier
        else {
            print("CODE : Button have no type assign")
            return
        }
    
        switch type {
        case "AD" :
            generateNewCode(ofType: .AD)
        case "AA" :
            generateNewCode(ofType: .AA)
        case "SD" :
            generateNewCode(ofType: .SD)
        case "SA" :
            generateNewCode(ofType: .SA)
        default:
            print("CODE : Account Type Error")
        }
    }

    
    func generateNewCode(ofType type : PPACtion.AccountType){
        let uid = UUID().uuidString
        
        PPACtion().generatedCode(owner: testUser, codeId: uid, type: type){
            (code) in
            uids.append(uid)
            codeTableView.reloadData()
        }

    }
    
}


extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CodeCell")
            else { return UITableViewCell() }
        cell.textLabel?.text = uids[indexPath.row]
        
        
        return cell
    }
}




