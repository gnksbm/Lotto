//
//  Builder.swift
//  Lotto
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

@dynamicMemberLookup
struct Builder<Base: AnyObject> {
    private let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>
    ) -> ((Value) -> Builder<Base>) {
        { [base] value in
            base[keyPath: keyPath] = value
            return Builder(base)
        }
    }
    
    subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>
    ) -> ((Value) -> Base) {
        { [base] value in
            base[keyPath: keyPath] = value
            return base
        }
    }
    
    func action(_ block: (Base) -> Void) -> Builder<Base> {
        block(base)
        return Builder(base)
    }
    
    func finalize() -> Base {
        base
    }
}
