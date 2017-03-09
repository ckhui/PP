//
//  BuildingGridLayout
//  collectionViewDemo
//
//  Created by NEXTAcademy on 2/17/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class BuildingGridLayout: UICollectionViewLayout {
    
    var blockSize : CGSize = CGSize(width: 80, height: 50)
    
    var itemsSize = [CGSize]()
    var contentSize = CGSize()
    
    var oriSize = CGSize() {
        didSet{
            contentSize = oriSize
        }
    }
    
    var verticalLock = false {
        didSet{
            adjustSizeForDirectionLock()
        }
    }
    
    var horizontalLock = false {
        didSet{
            adjustSizeForDirectionLock()
        }
    }
    
    var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    
    private func adjustSizeForDirectionLock() {
        var height = oriSize.height
        var width = oriSize.width
        
        if verticalLock {
            height = self.collectionView!.frame.height
        }
        if horizontalLock {
            width = self.collectionView!.frame.width
        }
        contentSize = CGSize(width: width, height: height)
        print("size : \(contentSize)")
    }
    
    override func prepare() {
        if self.collectionView?.numberOfSections == 0 {
            return
        }
        
        //        layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        //
        //        let path = IndexPath(item: 0, section: 0)
        //        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: path)
        //
        //        let headerHeight = CGFloat(contentSize.height / 4)
        //        attributes.frame = CGRect(x: 0, y: 0, width: self.collectionView!.frame.size.width, height: headerHeight)
        //
        //        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        //        layoutAttributes[headerKey] = attributes // 2
        
        
        //var yOffset = headerHeight
        let numberOfSections = self.collectionView!.numberOfSections
        
        if layoutAttributes.count > 0 {
            for section in 0 ..< numberOfSections {
                var numberOfItems : Int = self.collectionView!.numberOfItems(inSection: section)
                
                //var xOffset : CGFloat = 10.0 //self.horizontalInset
                for item in 0 ..< numberOfItems {
                    
                    /*
                     x,x,x,x,x,x
                     x,0,0,0,0,0
                     x,0,0,0,0,0
                     
                     target x
                     */
                    if section != 0 && item != 0 {
                        continue
                    }
                    
                    let indexPath = IndexPath(item: item, section: section)
                    let attributes =  layoutAttributesForItem(at: indexPath)!
                    //                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath) // 4
                    
                    if section == 0 {
                        var frame = attributes.frame
                        frame.origin.y = self.collectionView!.contentOffset.y
                        attributes.frame = frame
                    }
                    
                    if item == 0 {
                        var frame = attributes.frame
                        frame.origin.x = self.collectionView!.contentOffset.x
                        attributes.frame = frame
                    }
                    
                    
                    
                    
                }
            }
            return
        }
        
        
        //        if (itemsSize.count != numberOfColumns) {
        //            self.calculateItemsSize()
        //        }
        
        var column = 0
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0
        var contentWidth : CGFloat = 0
        var contentHeight : CGFloat = 0
        var indexPath = IndexPath()
        for section in 0..<self.collectionView!.numberOfSections {
            
            let numberOfItems = self.collectionView!.numberOfItems(inSection: section)
            for item in 0 ..< numberOfItems {
                
                let itemSize = blockSize//itemsSize[item]
                indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                if section == 0 && item == 0 {
                    attributes.zIndex = 1024;
                    
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width + 40, height: itemSize.height + 40).integral
                    attributes.frame.origin.x = self.collectionView!.contentOffset.x
                    attributes.frame.origin.y = self.collectionView!.contentOffset.y
                    
                } else  if section == 0 || item == 0 {
                    attributes.zIndex = 1023
                    if section == 0 {
                        var frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height + 40).integral //attributes.frame
                        frame.origin.y = self.collectionView!.contentOffset.y
                        attributes.frame = frame
                    }
                    if item == 0 {
                        var frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width + 40, height: itemSize.height).integral //attributes.frame
                        frame.origin.x = self.collectionView!.contentOffset.x
                        attributes.frame = frame
                    }
                }
                
                
                let key = layoutKeyForIndexPath(indexPath)
                layoutAttributes[key] = attributes
                
                xOffset += attributes.frame.width + 3//itemSize.width + 3
                column += 1
                
                if column == numberOfItems {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += attributes.frame.height + 3 //itemSize.height + 5
                }
            }
            
        }
        
        //        let lastAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        //        contentHeight = lastAttributes.frame.origin.y + lastAttributes.frame.size.height
        //        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        let lastAttributes = layoutAttributesForItem(at: indexPath)!
        contentHeight = lastAttributes.frame.origin.y + lastAttributes.frame.size.height
        //self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        self.oriSize = CGSize(width: contentWidth, height: contentHeight)
        
        
        //        yOffset += itemSize.height // 10
        //
        //        contentSize = CGSize(width: self.collectionView!.frame.size.width, height: yOffset + self.verticalInset) // 11
        
        
    }
    
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true //!newBounds.size.equalTo(self.collectionView!.frame.size)
        // Set this to YES to call prepareLayout on every scroll
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self.layoutAttributes[evaluatedObject as! String]
            return rect.intersects(layoutAttribute!.frame)
        }
        
        let dict = layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filtered(using: predicate)
        
        return dict.objects(forKeys: matchingKeys, notFoundMarker: NSNull()) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let key = layoutKeyForIndexPath(indexPath)
        return layoutAttributes[key]
    }
    
    func layoutKeyForIndexPath(_ indexPath : IndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    //    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //
    //        let headerKey = layoutKeyForIndexPath(indexPath)
    //        return layoutAttributes[headerKey]
    //    }
    
    //    func layoutKeyForHeaderAtIndexPath(_ indexPath : IndexPath) -> String {
    //        return "s_\(indexPath.section)_\(indexPath.row)"
    //    }
    
    
    
}
