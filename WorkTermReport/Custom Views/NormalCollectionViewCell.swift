//
//  NormalCollectionViewCell.swift
//  WorkTermReport
//
//  Created by Edward Liu on 2016-12-22.
//  Copyright © 2016 EdwardLiu. All rights reserved.
//

import UIKit

class NormalCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func instanceFromNib() -> NormalCollectionViewCell {
        let nib = UINib(nibName: "NormalCollectionViewCell", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! NormalCollectionViewCell
    }
}
