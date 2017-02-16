//
//  PropertyDetailsMainViewController.swift
//  PP
//
//  Created by NEXTAcademy on 2/14/17.
//  Copyright © 2017 ckhui. All rights reserved.
//

import UIKit

class PropertyDetailsMainViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var currentViewContoller = UIViewController()
    
    private lazy var propertyTypeVC: PropertyTypeViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PropertyTypeViewController") as! PropertyTypeViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var propertyBuildingVC: PropertyBuildingViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PropertyBuildingViewController") as! PropertyBuildingViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var propertyStatVC: PropertyStatViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PropertyStatViewController") as! PropertyStatViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var propertyDetailsVC: PropertyDetailsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PropertyDetailsViewController") as! PropertyDetailsViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        setupSegmentedControl()
        
        updateView()
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Details", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Type", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Building", at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: "Stat", at: 3, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        currentViewContoller = viewController
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        remove(asChildViewController: currentViewContoller)
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0 : add(asChildViewController: propertyDetailsVC)
        case 1 : add(asChildViewController: propertyTypeVC)
        case 2 : add(asChildViewController: propertyBuildingVC)
        case 3 : add(asChildViewController: propertyStatVC)
        default : break
        }
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
