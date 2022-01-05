//
//  UIColor+Extension.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/02.
//

import UIKit

extension UIColor {
    static var themeColor: UIColor {
        return UIColor(named: "themeColor")!
    }
    
    static var randomColor: UIColor {
        return  UIColor(red: .random(in: 0...1),
                             green: .random(in: 0...1),
                             blue: .random(in: 0...1),
                             alpha: 0.8)
    }
}
