//
//  HomeView.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//

import SwiftUI
import UIKit
struct HomeView: View {
    @State var model: HitokotoModel? = nil

    func fetch() {
//        model = nil
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

                    ActionView(model: $model)
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
            CircleButtonShape(systemImage: "arrow.clockwise")
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
    @EnvironmentObject var like: Like

    @Binding var model: HitokotoModel?

    var liked: Bool {
        if let model = model {
            return like.likes.first(where: { $0.id == (UUID(uuidString: model.uuid) ?? UUID()) }) != nil

        } else {
            return false
        }
    }

    @State private var showShareSheet = false

    @ViewBuilder
    var body: some View {
        if let model = model {
            HStack(spacing: 20) {
                Button(action: {
                    if HitokotoViewModel.isStored(uuid: UUID(uuidString: model.uuid)) {
                        if let uuid = UUID(uuidString: model.uuid) {
                            HitokotoViewModel.storeData(removeUUID: uuid)
                        }

                    } else {
                        HitokotoViewModel.storeData(add: LikeModel(id: UUID(uuidString: model.uuid) ?? UUID(), text: model.hitokoto, createdAt: Date(), from: model.from, author: model.creator))
                    }

                }, label: {
                    Image(systemName: liked ? "suit.heart.fill" : "suit.heart")
                        .foregroundColor(liked ? .red : .primary)
                        .font(.custom("icon", size: 28))
                })
                Button(action: {
                    showShareSheet = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.custom("icon", size: 28))
                        .foregroundColor(.primary)
                })
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: ["\(model.hitokoto) -- \(model.creator )"])
            }
        }
    }
}
// - MARK: https://developer.apple.com/forums/thread/123951
struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
