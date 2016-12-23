//
//  Extensions.swift
//  WorkTermReport
//
//  Created by Edward Liu on 2016-12-22.
//  Copyright © 2016 EdwardLiu. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
}

extension UIColor
{
    class  func makeColor(r: Int, g: Int, b: Int) -> UIColor
    {
        return UIColor.makeColor(r: r, g: g, b: b, a: 1.0)
    }
    
    class func makeColor(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor
    {
        let red: CGFloat = CGFloat(r) / 255.0
        let green: CGFloat = CGFloat(g) / 255.0
        let blue: CGFloat = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: a)
    }
    
    class func makeColor(hexString: String) -> UIColor {
        return hexString.colorWithHexString()
    }
    
    class func randomColor() -> UIColor {
        let randomNumber1 = arc4random_uniform(255)
        let randomNumber2 = arc4random_uniform(255)
        let randomNumber3 = arc4random_uniform(255)
        return UIColor.makeColor(r: Int(randomNumber1), g:Int(randomNumber2), b:Int(randomNumber3))
    }
}

extension String
{
    func colorWithHexString() -> UIColor {
        var cString:String = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
