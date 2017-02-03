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
    var user = User.testParentUser
    
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
        frDBref.child(user.type.rawValue).child(user.id).child("generatedCode").observeSingleEvent(of: .value , with: { (snapshot) in

            
            if snapshot.exists() {
                
                guard let temp = snapshot.value as? NSDictionary,
                      let codes = temp.allKeys as? [String]
                    else {
                        print ("CODE : No code generated")
                        return
                }
                
                for code in codes {
                    //TODO : get code info
                    //                let jsonVars = JSON(snapshot.value)
                    //                snapshot
                    //                for jsonVar in jsonVars {
                    //                    codeStr.append(jsonVar.0)
                    //                    print("ADS")
                    //                }
                }
            }
            else{
                print("CODE : firebase Path error")
            }
            
            //TO TEST : weather the queue is working if i have another block inside this block
            DispatchQueue.main.async {
                self.codeTableView.reloadData()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
//        frDBref.child("Code").observeSingleEvent(of: .value, with: { (snapshot) in
//            print("CODE : reading code data")
//            
//            if snapshot.exists() {
//                let jsonVars = JSON(snapshot.value)
//                for jsonVar in jsonVars {
//                    let newCode = Code(codeId: jsonVar.0, value: jsonVar.1)
//                    self.codes.append(newCode)
//                }
//                
//            }
//            else{
//                print("CODE : firebase Path error")
//            }
//            
//            DispatchQueue.main.async {
//                self.codeTableView.reloadData()
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }

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
