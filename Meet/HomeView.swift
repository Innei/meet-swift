//
//  HomeView.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//

import SwiftUI

struct HomeView: View {
    @State var model: HitokotoModel? = nil

    func fetch() {
        model = nil
        HitokotoViewModel.fetch {
            self.model = $0
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { reader in
                ZStack {
                    Preview(model: model)
                    VStack(spacing: 20) {
                        CircleButton(onPress: fetch)
                    }
                    .position(x: reader.size.width - 50, y: reader.size.height - 50)

                    ActionView(model: model)
                        .offset(x: 0, y: reader.size.height / 2 - 60)
                }
            }
            .navigationBarTitle("遇见", displayMode: .inline)
            .onAppear {
                fetch()
            }
        }
    }
}

struct CircleButton: View {
    @State var routeDeg: Double = 0
    var onPress: () -> Void
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
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
                onPress()
                self.routeDeg = 0

            })
            .rotationEffect(.degrees(routeDeg))
        })
    }
}

struct Preview: View {
    var model: HitokotoModel?

    func nowDateFormater() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "zh_CN")

        let dateString = dateFormatter.string(from: Date())
        return dateString
    }

    @ViewBuilder
    var body: some View {
        if model == nil {
            Text("载入中...")
        } else if let m = model {
            VStack(spacing: 5) {
                Text(nowDateFormater())

                Text(m.hitokoto).foregroundColor(.blue).font(.custom("text", size: 24))

                HStack {
                    Spacer()

                    Text(model?.creator ?? model?.from ?? "").font(.footnote)
                }
            }.padding(.horizontal, 20)
        }
    }
}

struct ActionView: View {
    var model: HitokotoModel?
    @State var liked = false
    @ViewBuilder
    var body: some View {
        if let model = model {
            HStack(spacing: 20) {
                Button(action: {
                    HitokotoViewModel.storeData(add: LikeModel(id: UUID(uuidString: model.uuid) ?? UUID(), text: model.hitokoto, createdAt: Date(), from: model.from, author: model.creator))

                    withAnimation {
                        liked.toggle()
                    }
                }, label: {
                    Image(systemName: liked ? "suit.heart.fill" : "suit.heart")
                        .foregroundColor(liked ? .red : .primary)
                        .font(.custom("icon", size: 28))
                })

                Image(systemName: "square.and.arrow.up")
                    .font(.custom("icon", size: 28))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
