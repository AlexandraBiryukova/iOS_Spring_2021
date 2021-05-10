//
//  View+AnimationCompletion.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/11/21.
//

import SwiftUI

struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {
    var animatableData: Value {
        didSet { notifyCompletionIfFinished() }
    }

    private var targetValue: Value
    private var completion: () -> Void

    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }

    func body(content: Content) -> some View { content }
    
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue  else { return }
        DispatchQueue.main.async {
            self.completion()
        }
    }
}

extension View {
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}
