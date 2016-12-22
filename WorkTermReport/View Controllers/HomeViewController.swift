//
//  HomeViewController.swift
//  WorkTermReport
//
//  Created by Edward Liu on 2016-12-22.
//  Copyright © 2016 EdwardLiu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // State variables
    private var deviceType = UserDefaults.standard.string(forKey: Constants.deviceIdiomKey)
    
    private var screenSize: CGRect {
        get {
            return UIScreen.main.bounds
        }
    }

    private let sectionInsetsPhone = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    private let sectionInsetsPad = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
    private let interCellVerticalSpacing = CGFloat(8)
    private let interCellHorizontalSpacing = CGFloat(8)
    private let padRowHeight = CGFloat(60)
    private let phoneRowHeight = CGFloat(50)
    
    var sectionWidth: CGFloat {
        get {
            if deviceType == Constants.deviceTypePad {
                return self.screenSize.width - (sectionInsetsPad.left + sectionInsetsPad.right)
            } else if deviceType == Constants.deviceTypePhone {
                return self.screenSize.width - (sectionInsetsPhone.left + sectionInsetsPhone.right)
            } else {
                return CGFloat(0)
            }
        }
    }
    
    // Other variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "NormalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.normalCollectionViewIdentifier)
        self.collectionView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let normalCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.normalCollectionViewIdentifier, for: indexPath)
        normalCell.layer.cornerRadius = 5
        return normalCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    // Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interCellVerticalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.deviceType == Constants.deviceTypePad {
            return self.sectionInsetsPad
        } else if self.deviceType == Constants.deviceTypePhone {
            return self.sectionInsetsPhone
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if deviceType == Constants.deviceTypePad {
            let calculatedWidth = (self.sectionWidth - self.interCellHorizontalSpacing * 2)/3
            return CGSize.init(width: calculatedWidth, height: 80)
        } else if self.deviceType == Constants.deviceTypePhone {
            return CGSize.init(width: self.sectionWidth, height: 60)
        } else {
            return CGSize.init(width: self.sectionWidth, height: 60)
        }
    }


}

