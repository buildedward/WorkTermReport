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
    @IBOutlet weak var deleteToolbarButton: UIBarButtonItem!
    @IBOutlet weak var editToolbarButton: UIBarButtonItem!
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptySubtitle: UILabel!
    
    // State variables
    private var deviceType = UserDefaults.standard.string(forKey: Constants.deviceIdiomKey) ?? Constants.deviceTypePhone
    
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
    private var deletionArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        let defaults = UserDefaults.standard
//        defaults.set(nil, forKey: "USER_DATA_TITLES")
//        defaults.set(nil, forKey: "USER_DATA_COUNTS")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "NormalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.normalCollectionViewIdentifier)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.allowsSelection = false
        self.collectionView.allowsMultipleSelection = false
        
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.leftBarButtonItem = addButton
        let clearButton = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(clearAllTapped))
        self.navigationItem.rightBarButtonItem = clearButton
        self.navigationItem.title = "LOGGER"
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
        if let countArray = defaults.array(forKey: "USER_DATA_COUNTS") as? [Int] {
            let count = countArray[indexPath.row]
            normalCell.setLabel(title: self.userItems[indexPath.row], count: count, index: indexPath.row)
        } else {
            normalCell.setLabel(title: self.userItems[indexPath.row], index: indexPath.row)
        }
        normalCell.beginEditing(style: self.currentSelectionStyle, deviceType: self.deviceType)
        return normalCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.userItems.count == 0 {
            self.emptyTitle.isHidden = false
            self.emptySubtitle.isHidden = false
        } else {
            self.emptyTitle.isHidden = true
            self.emptySubtitle.isHidden = true
        }
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
        
        if self.currentSelectionStyle == "none" {
            return
        } else if self.currentSelectionStyle == "edit" {
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
        } else if self.currentSelectionStyle == "delete" {
            if cell.setSelected() {
                self.deletionArray.append(indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! NormalCollectionViewCell
        if self.currentSelectionStyle == "delete" {
            if !cell.setSelected() {
                for (index, number) in deletionArray.enumerated() {
                    if number == indexPath.row {
                        deletionArray.remove(at: index)
                    }
                }
            }
        }
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
    
    func deleteSelected() {
        if self.currentSelectionStyle == "delete" {
            let defaults = UserDefaults.standard
            self.deletionArray = self.deletionArray.sorted(by: >)
            if let array = defaults.array(forKey: "USER_DATA_TITLES") {
                var newTitleArray = array
                var newCountArray = defaults.array(forKey: "USER_DATA_COUNTS")
                for index in self.deletionArray {
                    newTitleArray.remove(at: index)
                    newCountArray?.remove(at: index)
                }
                if newTitleArray.count == 0 {
                    defaults.set(nil, forKey: "USER_DATA_TITLES")
                } else {
                    defaults.set(newTitleArray, forKey: "USER_DATA_TITLES")
                }
                if newCountArray?.count == 0 {
                    defaults.set(nil, forKey: "USER_DATA_COUNTS")
                } else {
                    defaults.set(newCountArray, forKey: "USER_DATA_COUNTS")
                }
                self.deletionArray = []
                self.collectionView.reloadData()
            }
        }
    }
    
    // Actions
    @IBAction func clearAllTapped(_ sender: AnyObject) {
        let alert = UIAlertController.init(title: "Confirm", message: "Are you sure you want to delete all of your items?", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {
            (alertAction) in
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "USER_DATA_TITLES")
            defaults.set(nil, forKey: "USER_DATA_COUNTS")
            self.collectionView.reloadData()
        })
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
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
        self.collectionView.allowsSelection = self.currentSelectionStyle == "edit" ? false : true
        self.collectionView.allowsMultipleSelection = false
        (sender as! UIBarButtonItem).title = self.currentSelectionStyle == "edit" ? "Edit" : "Finish Editing"
        self.navigationItem.title = self.currentSelectionStyle == "edit" ? "LOGGER" : nil
        self.navigationItem.prompt = self.currentSelectionStyle == "edit" ? nil : "Please select an item to edit."
        self.navigationItem.leftBarButtonItem?.isEnabled = self.currentSelectionStyle == "edit" ? true : false
        self.navigationItem.rightBarButtonItem?.isEnabled = self.currentSelectionStyle == "edit" ? true : false
        self.deleteToolbarButton.isEnabled = self.currentSelectionStyle == "edit" ? true : false
        self.currentSelectionStyle = self.currentSelectionStyle == "edit" ? "none" : "edit"
        self.collectionView.reloadData()
    }
    
    @IBAction func deleteToolButtonTapped(_ sender: Any) {
        self.collectionView.allowsSelection = self.currentSelectionStyle == "delete" ? false : true
        self.collectionView.allowsMultipleSelection = self.currentSelectionStyle == "delete" ? false : true
        (sender as! UIBarButtonItem).title = self.currentSelectionStyle == "delete" ? "Delete" : "Finish"
        self.navigationItem.title = self.currentSelectionStyle == "delete" ? "LOGGER" : nil
        self.navigationItem.prompt = self.currentSelectionStyle == "delete" ? nil : "Please select items to remove."
        self.navigationItem.leftBarButtonItem?.isEnabled = self.currentSelectionStyle == "delete" ? true : false
        self.navigationItem.rightBarButtonItem?.isEnabled = self.currentSelectionStyle == "delete" ? true : false
        self.deleteSelected()
        self.editToolbarButton.isEnabled = self.currentSelectionStyle == "delete" ? true : false
        self.currentSelectionStyle = self.currentSelectionStyle == "delete" ? "none" : "delete"
        self.collectionView.reloadData()
    }
}

