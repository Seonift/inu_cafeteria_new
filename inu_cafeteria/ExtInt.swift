//
//  ExtInt.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation

extension Int {
    func toMoney() -> String {
        // 5000 -> 5,000 String
        let numFormatter : NumberFormatter = NumberFormatter();
        numFormatter.numberStyle = .decimal
        let v = NSNumber(integerLiteral: self)
        let price : String = numFormatter.string(from: v)!
        return price
    }
}
