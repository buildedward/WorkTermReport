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
    
    // Layout Constraints
    @IBOutlet weak var counterBoxLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var rightMostItemTrailingSpace: NSLayoutConstraint!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectedBackgroundView?.backgroundColor = UIColor.lightGray
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
    
    func beginEditing(style: String, deviceType: String) {
        if style == "edit" {
            UIView.animate(withDuration: 0.2, animations: {
                // Set heights because we know it's 80 cell height for pad and 60 for phone
                if deviceType == Constants.deviceTypePad {
                    // No implementation yet
                } else if deviceType == Constants.deviceTypePhone {
                    self.counterBoxLeadingSpace.constant = -52
                    self.rightMostItemTrailingSpace.constant = -(CGFloat(8 * 2 + 36 * 2))
                }
            })
        } else if style == "delete" {
            UIView.animate(withDuration: 0.2, animations: {
                if deviceType == Constants.deviceTypePad {
                    // No implementation yet
                } else if deviceType == Constants.deviceTypePhone {
                    self.counterBoxLeadingSpace.constant = -52
                    self.rightMostItemTrailingSpace.constant = -(CGFloat(8 * 2 + 36 * 2))
                }
            })
        } else if style == "none" {
            UIView.animate(withDuration: 0.2, animations: {
                if deviceType == Constants.deviceTypePad {
                    // No implementation yet
                } else if deviceType == Constants.deviceTypePhone {
                    self.counterBoxLeadingSpace.constant = 8
                    self.rightMostItemTrailingSpace.constant = 8
                    self.backgroundColor = UIColor.makeColor(hexString: "007F00")
                }
            })
        }
    }
    
    func setSelected() -> Bool {
        self.backgroundColor = self.backgroundColor == UIColor.makeColor(hexString: "007F00").withAlphaComponent(0.5) ? UIColor.makeColor(hexString: "007F00") : UIColor.makeColor(hexString: "007F00").withAlphaComponent(0.5)
        return self.backgroundColor == UIColor.makeColor(hexString: "007F00").withAlphaComponent(0.5) ? true : false
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
