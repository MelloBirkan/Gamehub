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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gamesViewModel)
        }
    }
}
