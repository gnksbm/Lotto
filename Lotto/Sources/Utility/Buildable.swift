//
//  Buildable.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

protocol Buildable { }

extension Buildable where Self: AnyObject {
    var builder: Builder<Self> {
        Builder(self)
    }
    
    func build(_ block: (_ builder: Builder<Self>) -> Builder<Self>) -> Self {
        block(Builder(self)).finalize()
    }
}

extension NSObject: Buildable { }
