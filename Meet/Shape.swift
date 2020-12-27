//
//  Shape.swift
//  Meet
//
//  Created by Innei on 2020/12/27.
//

import SwiftUI

struct CircleButtonShape: View {
    var systemImage: String
    var color: Color = .pink
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50, alignment: .center)
                .shadow(radius: 3)
            Image(systemName: systemImage).foregroundColor(.white)
        }
    }
}
