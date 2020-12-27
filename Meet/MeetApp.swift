//
//  MeetApp.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//

import SwiftUI

@main
struct MeetApp: App {
    @State var activeTabIndex = 0

    let like = HitokotoViewModel.like

    var body: some Scene {
        return WindowGroup {
            TabView(selection: $activeTabIndex) {
                ContentView().tabItem {
                    Label("遇见", systemImage: activeTabIndex != 0 ? "circle" : "largecircle.fill.circle")
                        .onTapGesture {
                            activeTabIndex = 0
                        }
                }
                .tag(0)

                LikeView().tabItem {
                    Label("喜欢", systemImage: activeTabIndex != 1 ? "heart.circle" : "heart.circle.fill")
                        .onTapGesture {
                            activeTabIndex = 1
                        }
                }
                .tag(1)
            }
            .accentColor(.pink)
            .environmentObject(like)
        }
    }
}
