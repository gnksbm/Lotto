//
//  APIURL.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

struct APIURL {
    static func lottoURL(round: Int) -> URL? {
        URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)")
    }
}
