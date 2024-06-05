//
//  LottoAnnouncement.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

import Alamofire

struct LottoAnnouncement: Codable {
    @UserDefaultsWrapper(
        key: .recentlyRound,
        defaultValue: LottoAnnouncement(date: "2024-03-16", round: 1111)
    )
    private static var latestAnnouncement
    
    static var roundRange: Range<Int> {
        1..<latestAnnouncement.round + 1
    }
    
    static func updateLatestInfo(
        completion: @escaping (LottoResponse) -> Void
    ) {
        let latestRound = latestAnnouncement.round
        guard let date = latestAnnouncement.date.formatted(dateFormat: .lottoDate)
        else {
            fetchLotto(round: latestRound) { response in
                completion(response)
            }
            return
        }
        let newRound = latestRound + Int(date.distance(to: .now) / (86400 * 7))
        fetchLotto(round: newRound) { response in
            completion(response)
        }
    }
    
    private static func fetchLotto(
        round: Int,
        completion: @escaping (LottoResponse) -> Void
    ) {
        if let url = APIURL.lottoURL(round: round) {
            AF.request(url)
                .responseDecodable(of: LottoResponse.self) { response in
                    switch response.result {
                    case .success(let success):
                        latestAnnouncement = LottoAnnouncement(
                            date: success.announceDate,
                            round: success.round
                        )
                        completion(success)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    private let date: String
    private let round: Int
}
