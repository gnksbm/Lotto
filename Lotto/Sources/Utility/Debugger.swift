//
//  Debugger.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

enum Debugger {
    static func debugging(
        _ message: Any,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        print("🖲️", file, line,function, "\n🖲️", message)
    }

    static func error(
        _ error: Error,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        print("⛔️", file, line, function,"\n", "⛔️", error.localizedDescription)
    }
}
