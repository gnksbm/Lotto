//
//  UIColor+.swift
//  Lotto
//
//  Created by gnksbm on 6/4/24.
//

import UIKit

extension UIColor {
    static func getLottoBallColor(winningNum: Int) -> UIColor? {
        switch winningNum {
        case 1...10:
            UIColor.lottoRed
        case 11...20:
            UIColor.lottoOrange
        case 21...30:
            UIColor.lottoYellow
        case 31...40:
            UIColor.lottoGreen
        case 41...45:
            UIColor.lottoBlue
        default:
            nil
        }
    }
}
