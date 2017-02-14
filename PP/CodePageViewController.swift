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
    var user = User.currentUser
    var codes = [Code]()
    var frDBref: FIRDatabaseReference!
    
    @IBOutlet weak var codeTableView: UITableView! {
        didSet{
            codeTableView.delegate = self
            codeTableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frDBref = FIRDatabase.database().reference()
        fetchAllCodeData()

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
