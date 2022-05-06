//
//  MnemosyneApp.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/6/20.
//

import SwiftUI

@main
struct MnemosyneApp: App {
    @StateObject private var achievementStore = AchievementStore()
    @StateObject private var jobStore = JobStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                JobsView()
                ProfileView()
            }
            .environmentObject(achievementStore)
            .environmentObject(jobStore)
            .onAppear(perform: jobStore.loadJobs)
        }
    }
}
