//
//  NumericValidator.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

struct NumericValidator {
    static func validateInput(
        input: String?,
        range: Range<Int>,
        inputDescription: String = ""
    ) throws -> Int {
        guard let input else { throw NumericInputError.unknown }
        guard !input.isEmpty
        else { throw NumericInputError.emptyInput(inputDescription) }
        guard !input.contains(" ")
        else { throw NumericInputError.containSpace(inputDescription) }
        guard let int = Int(input)
        else { throw NumericInputError.nonNumericInput(inputDescription) }
        guard range ~= int
        else { throw NumericInputError.outOfRange(inputDescription) }
        return int
    }
}
