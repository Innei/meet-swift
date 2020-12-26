//
//  HomeView.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//

import SwiftUI

struct HomeView: View {
    @State var routeDeg: Double = 0
    var body: some View {
        NavigationView {
            GeometryReader { reader in
                ZStack {
                    VStack(spacing: 5) {
                        Text("2020-12-25")

                        Text("悲伤教会了我喜悦。").foregroundColor(/*@START_MENU_TOKEN@*/ .blue/*@END_MENU_TOKEN@*/).font(.custom("text", size: 24))

                        HStack {
                            Spacer()

                            Text("秋之回忆").font(.footnote)
                        }
                    }.padding(.horizontal, 20)

                    VStack(spacing: 20) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                routeDeg = 720
                            }
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .shadow(radius: 3)
                                Image(systemName: "arrow.clockwise").foregroundColor(.white)
                            }
                            .modifier(AnimatableModifierDouble(bindedValue: routeDeg) {
                                self.routeDeg = 0

                            })
                            .rotationEffect(.degrees(routeDeg))

                        })
                    }

                    .position(x: reader.size.width - 50, y: reader.size.height - 50)
                }
            }

            .navigationBarTitle("遇见", displayMode: .inline)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
