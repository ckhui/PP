//
//  PropertiesViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/14/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import FirebaseDatabase
import SwiftyJSON

class PropertiesViewController: UIViewController {

    @IBOutlet weak var propertyTableView: UITableView! {
        didSet{
            propertyTableView.dataSource = self
            propertyTableView.delegate = self
            propertyTableView.emptyDataSetSource = self
            propertyTableView.emptyDataSetDelegate = self
        }
    }
    var frDBref: FIRDatabaseReference!
    var properties = [Property]()
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC load : Property")
        frDBref = FIRDatabase.database().reference()
        user = User.currentUser
        
        fetchAllPropertyData()
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
            print("Property : load Error \(error.localizedDescription)")
        }
    }
    
    func fetchProperty(_ propertyID : String){
        frDBref.child("Property").child(propertyID).observe(.value, with: { (snap) in
            print("Queue : get Property")
            let propertyJson = JSON(snap.value)
            let newProperty = Property(name: propertyJson["name"].stringValue, id: snap.key)
            self.appendProperty(newProperty)
        })
    }
    
    func appendProperty(_ property : Property){
        
        print("Queue : append Property")
        let _index = properties.index { return $0.id == property.id}
        if let index = _index {
            properties[index] = property
        }
        else {
            properties.append(property)
        }
        
        propertyTableView.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPropertyDetailVC" {
            if let detailsVC = segue.destination as? PropertyDetailsMainViewController,
                let index = sender as? IndexPath {
                Property.selectedProperty = properties[index.row]
            }
            
        }else if segue.identifier == "ToAddPropertyVC" {
            return
        }
    }
 

}

extension PropertiesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell")
            else { return UITableViewCell() }
        
        cell.textLabel?.text = properties[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPropertyDetailVC", sender: indexPath)
    }
    
}

extension PropertiesViewController : DZNEmptyDataSetSource , DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "EmptyTableView_property")?.resizeImage(newWidth: propertyTableView.frame.width / 2)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Property Found"
        let attributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        let string = NSAttributedString(string: text, attributes: attributes)
        return string
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Click To Add Property"
        let attributes = [NSForegroundColorAttributeName : UIColor.yellow]
        let string = NSAttributedString(string: text, attributes: attributes)
        return string
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)!]
        let string = NSAttributedString(string: "Add Property", attributes: myAttribute)
        return string
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.gray
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        performSegue(withIdentifier: "ToAddPropertyVC", sender: self)
    }
    
}
