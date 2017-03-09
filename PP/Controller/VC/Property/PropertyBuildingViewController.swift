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
        buildingCollectionView.collectionViewLayout = BuildingGridLayout()
        buildingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "corner")
        buildingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "top")
        buildingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "left")
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        if indexPath.section == 0 && indexPath.row == 0{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "corner", for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell
        }
        else if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top", for: indexPath)
            if (cell.layer.sublayers?.count ?? 0) > 0 {
                let gradient = CAGradientLayer()
                gradient.frame = cell.bounds
                gradient.colors = [UIColor.brown.cgColor, UIColor.white.cgColor]
                
                gradient.locations = [0.5, 0.35]
                cell.layer.insertSublayer(gradient, at: 0)
            }
            return cell

        }else if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "left", for: indexPath)
            if (cell.layer.sublayers?.count ?? 0) > 0 {
                let gradient = CAGradientLayer()
                gradient.frame = cell.bounds
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 0)
                gradient.colors = [UIColor.brown.cgColor, UIColor.white.cgColor]
                gradient.locations = [0.5, 0.35]
                cell.layer.insertSublayer(gradient, at: 0)
                
                return cell
            }
        }
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell
            else { return UICollectionViewCell() }
        
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
        
        
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //direction Lock
        
        if indexPath.section == 0 && indexPath.item != 0 {
            //row selected
            
        }else if indexPath.section != 0 && indexPath.row == 0 {
            //column selected
            
        }
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func didSelectRow(row : Int) {
        
    }
    
    private func didSelectColumn(column : Int) {
        
    }
}
