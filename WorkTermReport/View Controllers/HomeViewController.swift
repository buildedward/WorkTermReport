//
//  HomeViewController.swift
//  WorkTermReport
//
//  Created by Edward Liu on 2016-12-22.
//  Copyright © 2016 EdwardLiu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // State variables
    var deviceType = UserDefaults.standard.string(forKey: Constants.deviceIdiomKey) {
        willSet {
                self.sectionWidth = CGFloat(self.screenSize.width - (self.sectionInsetsPad.left + self.sectionInsetsPad.right))
        }
    }
    
    var sectionWidth: CGFloat = CGFloat(0)
    var screenSize: CGRect {
        get {
            return UIScreen.main.bounds
        }
    }
    
    var numberOfCellsPerRow = [Int]()
    
    let sectionInsetsPhone = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    let sectionInsetsPad = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
    let interCellVerticalSpacing = CGFloat(8)
    let interCellHorizontalSpacing = CGFloat(8)
    let padRowHeight = CGFloat(60)
    let phoneRowHeight = CGFloat(50)
    
    // Other variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        <#code#>
    }


}

