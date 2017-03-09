//
//  PorpertyBuildingViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/14/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit

class PropertyBuildingViewController: UIViewController {
    
    @IBOutlet weak var buildingCollectionView: UICollectionView!
    var rowLock : Int!
    var columnLock : Int!
    var layout = BuildingGridLayout()
    var property = Property.selectedProperty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initCollectionView(){
        buildingCollectionView.dataSource = self
        buildingCollectionView.delegate = self
        buildingCollectionView.collectionViewLayout = layout
        
        buildingCollectionView.register(BuildingBlockCollectionViewCell.cellNib, forCellWithReuseIdentifier: BuildingBlockCollectionViewCell.identifire)
        
         buildingCollectionView.register(BuildingBlockCollectionViewCell.cellNib, forCellWithReuseIdentifier: BuildingBlockCollectionViewCell.identifireTop)
         buildingCollectionView.register(BuildingBlockCollectionViewCell.cellNib, forCellWithReuseIdentifier: BuildingBlockCollectionViewCell.identifireLeft)
        
        buildingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "corner")
//        buildingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "top")
//        buildingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "left")
        buildingCollectionView.reloadData()
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

extension PropertyBuildingViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return property.floor ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return property.column ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        if indexPath.section == 0 && indexPath.row == 0{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "corner", for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell
        }
        else if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BuildingBlockCollectionViewCell.identifireTop, for: indexPath) as? BuildingBlockCollectionViewCell {
            if (cell.layer.sublayers?.count ?? 0) > 0 {
                let gradient = CAGradientLayer()
                gradient.frame = cell.bounds
                gradient.colors = [UIColor.brown.cgColor, UIColor.white.cgColor]
                
                gradient.locations = [0.5, 0.35]
                cell.layer.insertSublayer(gradient, at: 0)
            }
                cell.label.text = "\(indexPath.item)"
                cell.label.sizeToFit()
            
            return cell
            }
            
        }else if indexPath.item == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BuildingBlockCollectionViewCell.identifireLeft, for: indexPath) as? BuildingBlockCollectionViewCell {
            if (cell.layer.sublayers?.count ?? 0) > 0 {
                let gradient = CAGradientLayer()
                gradient.frame = cell.bounds
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 0)
                gradient.colors = [UIColor.brown.cgColor, UIColor.white.cgColor]
                gradient.locations = [0.5, 0.35]
                cell.layer.insertSublayer(gradient, at: 0)
                
                
            }
                cell.label.text = "\(indexPath.section)"
                return cell
            }
        }
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BuildingBlockCollectionViewCell.identifire, for: indexPath) as? BuildingBlockCollectionViewCell
            else { return UICollectionViewCell() }
        
        cell.backgroundColor = UIColor.randomColor()
        
        
        cell.label.text = "\(indexPath)"
        return cell
        
        
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //direction Lock
        
        if indexPath.section == 0 && indexPath.item != 0 {
            //column selected
            didSelectColumn(column: indexPath.item)
            
        }else if indexPath.section != 0 && indexPath.row == 0 {
            //row selected
            didSelectRow(row: indexPath.section)
        }else {
            
            let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
    private func didSelectRow(row : Int) {
        
        
        
        //TODO : scroll lock,
        //approach, get the current offset of collectionview, add the off set to the flow loyout
        /*
        if rowLock == nil {
            rowLock = row
            print("Lock \(row)")
            layout.verticalLock = true
            let indexPath = IndexPath(item: 0, section: row)
//            buildingCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }else if rowLock == row {
            rowLock = nil
            print("unlock \(row)")
            layout.verticalLock = false
        }
        */
    }
    
    private func didSelectColumn(column : Int) {


        /*
        if columnLock == nil {
            columnLock = column
            print("Lock \(column)")
            layout.horizontalLock = true
        }else if columnLock == column {
            columnLock = nil
            print("unlock \(column)")
            layout.horizontalLock = false
        }
         */
    }
}
