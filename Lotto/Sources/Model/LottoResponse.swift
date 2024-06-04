//
//  LottoResponse.swift
//  Lotto
//
//  Created by gnksbm on 6/4/24.
//

import UIKit

struct LottoResponse: Codable {
    let firstPrizeAmmount: Int
    let firstPrizeCount: Int
    let winningNum1: Int
    let winningNum2: Int
    let winningNum3: Int
    let winningNum4: Int
    let winningNum5: Int
    let winningNum6: Int
    let bonusNum: Int
    
    subscript(ballType: LottoBallType) -> Int {
        switch ballType {
        case .winningNum1:
            winningNum1
        case .winningNum2:
            winningNum2
        case .winningNum3:
            winningNum3
        case .winningNum4:
            winningNum4
        case .winningNum5:
            winningNum5
        case .winningNum6:
            winningNum6
        case .bonusNum:
            bonusNum
        }
    }
}

extension LottoResponse {
    static func getURL(round: Int) -> URL? {
        URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)")
    }
    
    var attributedString: NSMutableAttributedString {
        let result = NSMutableAttributedString()
        result.append(descriptionPrefix)
        result.append(ammountAttribute)
        result.append(descriptionSuffix)
        return result
    }
    
    private var normalAttribute: [NSAttributedString.Key : Any] {
        [.font: UIFont.systemFont(ofSize: 20)]
    }
    
    private var descriptionPrefix: NSAttributedString {
        NSAttributedString(
            string: "1등 당첨금 ",
            attributes: normalAttribute
        )
    }
    
    private var descriptionSuffix: NSAttributedString {
        NSAttributedString(
            string: "원 (당첨 복권수 \(firstPrizeCount)개)",
            attributes: normalAttribute
        )
    }
    
    private var ammountAttribute: NSAttributedString {
        NSAttributedString(
            string: firstPrizeAmmount.formatted(),
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
        )
    }
}

extension LottoResponse {
    enum CodingKeys: String, CodingKey {
        case firstPrizeAmmount = "firstWinamnt"
        case firstPrizeCount = "firstPrzwnerCo"
        case winningNum1 = "drwtNo1"
        case winningNum2 = "drwtNo2"
        case winningNum3 = "drwtNo3"
        case winningNum4 = "drwtNo4"
        case winningNum5 = "drwtNo5"
        case winningNum6 = "drwtNo6"
        case bonusNum = "bnusNo"
    }
}
