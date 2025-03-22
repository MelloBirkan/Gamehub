//
//  ContentView.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(GamesViewModel.self) private var gamesViewModel
    
    var body: some View {
        let games = gamesViewModel.games
        
        List(games) { game in
            Text(game.name ?? "No games")
        }
        .padding()
        .onAppear {
            gamesViewModel.fetchGames()
        }
    }
}

#Preview {
    ContentView()
        .environment(GamesViewModel())
}
