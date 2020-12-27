//
//  LikeView.swift
//  Meet
//
//  Created by Innei on 2020/12/27.
//

import SwiftUI

struct LikeView: View {
    @EnvironmentObject var like: Like

    var body: some View {
        NavigationView {
            List {
                ForEach(like.likes) { model in
                    Text(model.text)
                }
                .onDelete(perform: { indexSet in
                    HitokotoViewModel.storeData(removeAtIndexSet: indexSet)
                })
            }
            .navigationBarTitle("喜欢")
        }
    }
}

struct LikeView_Previews: PreviewProvider {
    static let like = Like()
    static var previews: some View {
        LikeView().environmentObject(like)
    }
}
