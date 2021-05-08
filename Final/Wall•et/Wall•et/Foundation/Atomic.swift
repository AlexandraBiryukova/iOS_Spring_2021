//
//  Atomic.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 2/28/21.
//

import Foundation

@propertyWrapper
final class Atomic<Value> {
    var wrappedValue: Value {
        get { queue.sync { value } }
        set { queue.sync { value = newValue } }
    }

    var projectedValue: Atomic<Value> {
        self
    }

    private let queue = DispatchQueue(label: "com.queue.atomic")
    private var value: Value

    init(wrappedValue: Value) {
        value = wrappedValue
    }

    func mutate(_ mutation: (inout Value) -> Void) {
        queue.sync {
            mutation(&value)
        }
    }
}
