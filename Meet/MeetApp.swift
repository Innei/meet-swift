//
//  MeetApp.swift
//  Meet
//
//  Created by Innei on 2020/12/26.
//


import SwiftUI

@main
struct MeetApp: App {
    var body: some Scene {

        return WindowGroup {
            TabView {
                ContentView().tabItem {
                    Label("遇见", systemImage: "largecircle.fill.circle")
                }
            }
        }
    }
}
