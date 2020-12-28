//
//  CreateView.swift
//  Meet
//
//  Created by Innei on 2020/12/27.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var like: Like

    @State var text: String = ""
    @State var author: String = ""
    @State var from: String = ""

    var body: some View {
        VStack {
            Spacer().frame(width: 100, height: 80, alignment: .leading)
            Input(label: "说点什么", text: $text)
            Input(label: "作者", text: $author)
            Input(label: "来自", text: $from)
            Spacer()
        }
        .padding(.horizontal, 20)
        .navigationBarTitle("灵感", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                like.add(item: LikeModel(text: text, createdAt: Date(), from: from.isEmpty ? nil : from, author: author.isEmpty ? nil : author))
                // back to LikeView
                // - MARK: https://stackoverflow.com/questions/56571349/custom-back-button-for-navigationviews-navigation-bar-in-swiftui
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("保存")
            }).disabled(text.isEmpty)
        )
    }

    struct Input: View {
        var label: String = ""
        @Binding var text: String
        var body: some View {
            HStack(alignment: .center) {
                Text(label)
                    .font(.callout)
                    .truncationMode(.tail)
                    .lineLimit(1)

                    .frame(width: 100, height: nil, alignment: .leading)
                TextField("", text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
