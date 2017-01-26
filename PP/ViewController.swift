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
    
    @IBOutlet weak var codeTableView: UITableView! {
        didSet{
            codeTableView.dataSource = self
            codeTableView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    var uids = [String]()
    var testUser = ParentUser.testParentUser
    
    @IBAction func generateCodeButtonPressed(_ sender: Any) {
        generateNewCode(ofType: .AD)
    }
    
    @IBAction func generateCode2(_ sender: Any) {
        generateNewCode(ofType: .AA)
    }
    
    func generateNewCode(ofType type : PPACtion.AccountType){
        let uid = UUID().uuidString

        PPACtion().generatedCode(owner: testUser, codeId: uid, type: type)
        
        //TODO : completion, add to array after database
        uids.append(uid)
        codeTableView.reloadData()
    }
    
    
    
    @IBAction func tempCheckBtn(_ sender: Any) {
        
        let id = uids.first ?? "none"
        //PPACtion().checkCodeExist(code: id)
        
        //checkCodeExist(code: id)
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




