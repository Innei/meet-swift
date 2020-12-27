//
//  LikeView.swift
//  Meet
//
//  Created by Innei on 2020/12/27.
//

import SwiftUI

struct LikeView: View {
    @EnvironmentObject var like: Like
    @State var editMode: EditMode = .inactive
    @State var isModalSheetShown: Bool = false

    @State var selectItem: LikeModel? = nil

    var body: some View {
        NavigationView {
            GeometryReader { reader in
                ZStack {
                    NavigationLink(
                        destination: CreateView(),
                        label: {
                            CircleButtonShape(systemImage: "pencil.circle", color: .blue)

                        })
                        .zIndex(1)
                        .position(x: reader.size.width - 50, y: reader.size.height - 50)

                    List {
                        ForEach(like.likes) { model in

                            Button(action: {
                                selectItem = model
                                if selectItem != nil {
                                    isModalSheetShown = true
                                }
                            }, label: {
                                Text(model.text)
                                    .truncationMode(.middle)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)
                            })
                        }

                        .onDelete(perform: { indexSet in
                            HitokotoViewModel.storeData(removeAtIndexSet: indexSet)
                        })
                        .onMove(perform: { indices, newOffset in
                            HitokotoViewModel.swap(from: indices, to: newOffset)
                        })
                    }

                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("喜欢")
                    .navigationBarItems(leading: editButton, trailing: rightActionButton)
                    .environment(\.editMode, self.$editMode)
                }
            }
        }
        .sheet(isPresented: $isModalSheetShown) {
            NavigationView {
                VStack {
                    LikeModalView(model: $selectItem)
                }
                .navigationBarItems(trailing:
                    Button("关闭",
                           action: {
                               isModalSheetShown = false
                           }
                    )
                )
            }
        }
    }

    @State var showingAlert: Bool = false

    @ViewBuilder
    var rightActionButton: some View {
        if editMode == .active {
            Button(action: {
                self.showingAlert = true

            }, label: {
                Text("清空").foregroundColor(.red)
            })
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("全部删除？"), message: Text("请三思哦"), primaryButton: .default(Text("嗯").foregroundColor(.red), action: {
                        HitokotoViewModel.clearStoreData()
                    }), secondaryButton: .default(Text("取消"), action: {
                        showingAlert = false
                    }))
                }
        }
    }

    var editButton: some View {
        Button(action: {
            withAnimation {
                editMode = editMode == .inactive ? .active : .inactive
            }

        }, label: {
            Text(editMode == .active ? "完成" : "编辑")
        })
    }
}

struct LikeModalView: View {
    @Binding var model: LikeModel?

    var dateFormat: String {
        if let model = model {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: model.createdAt)
        }
        return ""
    }

    @ViewBuilder
    var body: some View {
        if let model = self.model {
            VStack {
                Text(dateFormat)

                Text(model.text).foregroundColor(.blue).font(.custom("text", size: 24))

                HStack {
                    Spacer()

                    Text(model.author ?? model.from ?? "").font(.footnote)
                }
            }.padding(.horizontal, 20)
        }
    }
}

struct LikeView_Previews: PreviewProvider {
    static let like = Like()
    static var previews: some View {
        LikeView().environmentObject(like)
    }
}
