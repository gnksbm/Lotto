//
//  NumericInputError.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

enum NumericInputError: LocalizedError {
    case emptyInput(String)
    case containSpace(String)
    case nonNumericInput(String)
    case outOfRange(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emptyInput(let inputDescription):
            return "\(inputDescription)가 비었습니다"
        case .containSpace(let inputDescription):
            return "\(inputDescription)의 공백을 제거해주세요"
        case .nonNumericInput(let inputDescription):
            return "\(inputDescription)는 숫자만 입력해주세요"
        case .outOfRange(let inputDescription):
            return "올바른 \(inputDescription)를 입력해주세요"
        case .unknown:
            return "알 수 없는 오류입니다"
        }
    }
}
