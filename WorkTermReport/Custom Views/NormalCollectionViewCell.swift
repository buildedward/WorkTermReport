//
//  NormalCollectionViewCell.swift
//  WorkTermReport
//
//  Created by Edward Liu on 2016-12-22.
//  Copyright © 2016 EdwardLiu. All rights reserved.
//

import UIKit

class NormalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLabel(title: String, count: Int = 0, index: Int) {
        self.label.text = title
        if count == 1000 {
            self.counterLabel.text = "MAX"
        } else {
            self.counterLabel.text = String(count)
        }
        self.index = index
    }
    
    class func instanceFromNib() -> NormalCollectionViewCell {
        let nib = UINib(nibName: "NormalCollectionViewCell", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! NormalCollectionViewCell
    }
    
    @IBAction func upButtonPressed(_ sender: Any) {
        if self.counterLabel.text == "MAX" {
            return
        }
        let defaults = UserDefaults.standard
        var newCountArray = defaults.array(forKey: "USER_DATA_COUNTS") as! [Int]
        if newCountArray[index] != 1000 {
            newCountArray[index] += 1
            defaults.set(newCountArray, forKey: "USER_DATA_COUNTS")
        } else {
            return
        }
        
        let newValue = Int(self.counterLabel.text!)! + 1
        if newValue > Constants.maxValue {
            self.counterLabel.text = "MAX"
            return
        }
        self.counterLabel.text = String(newValue)
    }
    
    @IBAction func downButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        var newCountArray = defaults.array(forKey: "USER_DATA_COUNTS") as! [Int]
        if newCountArray[index] != 0 {
            newCountArray[index] -= 1
            defaults.set(newCountArray, forKey: "USER_DATA_COUNTS")
        } else {
            return
        }
        let newValue = Int(self.counterLabel.text!)! - 1
        if newValue == -1 {
            return
        }
        self.counterLabel.text = String(newValue)
    }
}
