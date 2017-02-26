//
//  PartnerViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/14/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PartnerViewController: UIViewController {

    @IBOutlet weak var partnerTableView: UITableView! {
        didSet{
            partnerTableView.delegate = self
            partnerTableView.dataSource = self
            partnerTableView.emptyDataSetDelegate = self
            partnerTableView.emptyDataSetSource = self
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("VC load : Partner")

        // Do any additional setup after loading the view.
    }
    
    var count = 1
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        count = count == 1 ? 0 : 1
        dump (User.currentUser)
        partnerTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PartnerViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            else { return UITableViewCell()}
        cell.backgroundColor = .red
        return cell
    }
}

extension PartnerViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        return UIImage(named: "fan")?.resizeImage(newWidth: partnerTableView.frame.width / 2)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "TITLE : Please Allow Photo Access"
        
        let attributes = [NSForegroundColorAttributeName : UIColor.darkGray]
        
        let string = NSAttributedString(string: text, attributes: attributes)
        
        return string
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Description : testing word here"
        
        let attributes = [NSForegroundColorAttributeName : UIColor.yellow]
        
        let string = NSAttributedString(string: text, attributes: attributes)
        
        return string
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]
        
         let string = NSAttributedString(string: "Button Title", attributes: myAttribute)
        
        return string
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.lightGray
    }
}
