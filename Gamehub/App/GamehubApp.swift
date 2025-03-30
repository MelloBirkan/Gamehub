//
//  GamehubApp.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import SwiftUI

@main
struct GamehubApp: App {
    @State private var gamesViewModel = GamesViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environment(gamesViewModel)
            } else {
                Onboarding()
            }
        }
    }
}
