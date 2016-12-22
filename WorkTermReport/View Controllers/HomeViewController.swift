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
    private var userItems: [String] {
        get {
            let defaults = UserDefaults.standard
            if let array = defaults.array(forKey: "USER_DATA_TITLES") {
                return array as! [String]
            } else {
                return []
            }
        }
    }
    private var currentSelectionStyle = "none"
    
    private var sectionWidth: CGFloat {
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
        self.collectionView.allowsSelection = false
        self.collectionView.allowsMultipleSelection = false
        
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.leftBarButtonItem = addButton
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
        let normalCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.normalCollectionViewIdentifier, for: indexPath) as! NormalCollectionViewCell
        normalCell.layer.cornerRadius = 5
        let defaults = UserDefaults.standard
        let countArray = defaults.array(forKey: "USER_DATA_COUNTS") as! [Int]
        let count = countArray[indexPath.row]
        normalCell.setLabel(title: self.userItems[indexPath.row], count: count, index: indexPath.row)
        return normalCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! NormalCollectionViewCell
        
        let alert = UIAlertController.init(title: "New Item", message: "Pleae enter your desired item's new name:", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = cell.label.text
        })
        
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {
            (alertAction) in
            let defaults = UserDefaults.standard
            if let array = defaults.array(forKey: "USER_DATA_TITLES") {
                if (alert.textFields?.first?.text?.isEmpty)! {
                    return
                }
                var newTitleArray = array
                newTitleArray[indexPath.row] = (alert.textFields?[0].text ?? "")
                defaults.set(newTitleArray, forKey: "USER_DATA_TITLES")
                self.collectionView.reloadData()
            }
        })
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: {
            (alertAction) in
            return
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
    
    // Actions
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        print(#function)
        
        if self.currentSelectionStyle != "none" {
            return
        }
        
        let alert = UIAlertController.init(title: "New Item", message: "Pleae enter your desired item's name:", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Title"
        })
        
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {
            (alertAction) in
            let defaults = UserDefaults.standard
            if let array = defaults.array(forKey: "USER_DATA_TITLES") {
                if (alert.textFields?.first?.text?.isEmpty)! {
                    return
                }
                var newTitleArray = array
                newTitleArray.append(alert.textFields?[0].text ?? "")
                defaults.set(newTitleArray, forKey: "USER_DATA_TITLES")
                var newCountArray = defaults.array(forKey: "USER_DATA_COUNTS")
                newCountArray?.append(0)
                defaults.set(newCountArray, forKey: "USER_DATA_COUNTS")
                self.collectionView.reloadData()
            } else {
                if (alert.textFields?.first?.text?.isEmpty)! {
                    return
                }
                var newTitleArray: [String] = []
                newTitleArray.append(alert.textFields?[0].text ?? "")
                defaults.set(newTitleArray, forKey: "USER_DATA_TITLES")
                var newCountArray: [Int] = []
                newCountArray.append(0)
                defaults.set(newCountArray, forKey: "USER_DATA_COUNTS")
                self.collectionView.reloadData()
            }
        })
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: {
            (alertAction) in
            return
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func editToolButtonTapped(_ sender: Any) {
        self.collectionView.allowsSelection = true
        self.collectionView.allowsMultipleSelection = false
        self.currentSelectionStyle = self.currentSelectionStyle == "edit" ? "none" : "edit"
    }
    
    @IBAction func deleteToolButtonTapped(_ sender: Any) {
        self.collectionView.allowsSelection = false
        self.collectionView.allowsMultipleSelection = true
        (sender as! UIBarButtonItem).title = self.currentSelectionStyle == "delete" ? "Delete" : "Finish"
        self.currentSelectionStyle = self.currentSelectionStyle == "delete" ? "none" : "delete"
    }
}

