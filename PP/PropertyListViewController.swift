//
//  PropertyListViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class PropertyListViewController: UIViewController {

    let user = User.currentUser
    var frDBref: FIRDatabaseReference!
    
    //TODO : Change to table / collection
    @IBOutlet weak var propertylist: UILabel! {
        didSet{
            propertylist.text = ""
        }
    }
    
    //TODO : other VC to handle add
    @IBOutlet weak var textField: UITextField! {
        didSet{
            textField.backgroundColor = UIColor.lightGray
        }
    }

    @IBAction func addPressed(_ sender: Any) {
        guard let text =  textField.text
            else { return }
        if text == "" {
            warningPopUp(withTitle: "input error", withMessage: "cannot be empty")
            return
        }
        
        //propertylist.text = propertylist.text! + "\(text) \n"
        
        
        PPACtion().addProperty(owner: user, propertyName: text)
        
        textField.text = ""
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("VC load : Property")
        print("user =")
        dump(user)
        
        print("saved User")
        dump(User.currentUser)
        
        frDBref = FIRDatabase.database().reference()
        
        fetchAllPropertyData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAllPropertyData(){
        frDBref.child(user.type.rawValue).child(user.id).child("property").observe(.childAdded , with: { (snapshot) in
            
            if snapshot.exists() {
                self.fetchProperty(snapshot.key)
            }
            else{
                print("Property : \(self.user.id) has no properties")
                print("Property : firebase Path error")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchProperty(_ code : String){
        frDBref.child("Property").child(code).observe(.value, with: { (snap) in
            print("Queue : get Property")
            let propertyJson = JSON(snap.value)
            let newProperty = Property(name: propertyJson["name"].stringValue, id: propertyJson["id"].stringValue)
            self.appendProperty(newProperty)
        })
    }
    
    var properties = [Property]()
    
    func appendProperty(_ property : Property){
        
        print("Queue : append Property")
        let _index = properties.index { return $0.id == property.id}
        if let index = _index {
            properties[index] = property
        }
        else {
            properties.append(property)
        }
        
        //codeTableView.reloadData()
        //let string = properties.map(return $0.id + $)
        propertylist.text = propertylist.text! + "\(property.name) \n"
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
