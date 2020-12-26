//
//  Animatable+Modifier.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//

import SwiftUI


struct AnimatableModifierDouble: AnimatableModifier {
    var targetValue: Double

    // SwiftUI gradually varies it from old value to the new value
    var animatableData: Double {
        didSet {
            checkIfFinished()
        }
    }

    var completion: () -> Void

    // Re-created every time the control argument changes
    init(bindedValue: Double, completion: @escaping () -> Void) {
        self.completion = completion

        // Set animatableData to the new value. But SwiftUI again directly
        // and gradually varies the value while the body
        // is being called to animate. Following line serves the purpose of
        // associating the extenal argument with the animatableData.
        animatableData = bindedValue
        targetValue = bindedValue
    }

    func checkIfFinished() {
        // print("Current value: \(animatableData)")
        if animatableData == targetValue {
            // if animatableData.isEqual(to: targetValue) {
            DispatchQueue.main.async {
                self.completion()
            }
        }
    }

    // Called after each gradual change in animatableData to allow the
    // modifier to animate
    func body(content: Content) -> some View {
        // content is the view on which .modifier is applied
        content
            // We don't want the system also to
            // implicitly animate default system animatons it each time we set it. It will also cancel
            // out other implicit animations now present on the content.
            .animation(nil)
    }
}

