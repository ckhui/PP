//
//  CodePageViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/2/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON


class CodePageViewController: UIViewController {

    //TEMP : testing user
    var user : User!
    var codes = [Code]()
    var frDBref: FIRDatabaseReference!
    
    @IBOutlet weak var codeTableView: UITableView! {
        didSet{
            codeTableView.delegate = self
            codeTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var generateCode1: UIButton!
    @IBOutlet weak var generateCode2: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC load : CodePage")
        user = User.currentUser
        frDBref = FIRDatabase.database().reference()
        initGenerateCodeButton()
        fetchAllCodeData()

    }
    
    func initGenerateCodeButton(){
        generateCode1.isEnabled = false
        generateCode2.isEnabled = false
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
        PPACtion().generatedCode(owner: user, codeId: uid, type: type)
    }

    
    func setGenerateCodeButtonFunction(button : UIButton, codeType : PPACtion.AccountType) {
        
        button.isEnabled = true
        
        button.setTitle("Gen \(codeType.rawValue) Code", for: .normal)
        button.accessibilityIdentifier = codeType.rawValue
        button.addTarget(self, action: #selector(generateCodeButtonPressed(_:)), for: .touchUpInside)
    }
    
    
    
    func fetchAllCodeData() {
        frDBref.child(user.type.rawValue).child(user.id).child("generatedCode").observe(.childAdded , with: { (snapshot) in

            
            if snapshot.exists() {
                
//                guard let temp = snapshot.value as? NSDictionary,
//                      let codes = temp.allKeys as? [String]
//                    else {
//                        print ("CODE : No code generated")
//                        return
//                }
//                
//                for code in codes {
//                    self.fetchCode(code)
//                }
                self.fetchCode(snapshot.key)
            }
            else{
                print("CODE : firebase Path error")
            }
   
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    func fetchCode(_ code : String){
        frDBref.child("Code").child(code).observe(.value, with: { (snap) in
                print("Queue : get code")
                let codeJson = JSON(snap.value)
                let newCode = Code(codeId: code, value: codeJson)
                self.appendCode(newCode)
        })
        
        

    }
    
    func appendCode(_ code : Code){
        
        print("Queue : append")
        let _index = codes.index { return $0.id == code.id}
        if let index = _index {
            codes[index] = code
        }
        else {
            codes.append(code)
        }
        
        codeTableView.reloadData()
        
    }
}

extension CodePageViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CodeTableViewCell
            else {
                return UITableViewCell()
        }
        
        let tempCode = codes[indexPath.row]
        cell.code = tempCode
        cell.displayCodeInfo()

        return cell
    }
    
}
