//
//  String+Extension.swift
//  SeSACCommunity
//
//  Created by SEUNGMIN OH on 2022/01/06.
//

import Foundation

extension String {
    var formattedDate: String {
        let components = self.components(separatedBy: ["T", ".", "-", ":"])
        let month = components[1]
        let day = components[2]
        let hr = String(format: "%02d", (Int(components[3])! + 9) % 24)
        let min = components[4]
        return "\(month)/\(day) \(hr):\(min)"
    }
}
