//
//  ContentView.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(GamesViewModel.self) private var gamesViewModel
    @State private var query: String = ""
    
    var body: some View {
        @Bindable var gamesViewModel = gamesViewModel
        let games = gamesViewModel.games
        
        NavigationStack {
            VStack {
                searchBar
                 
                if gamesViewModel.isSearching {
                    Spacer()
                    ProgressView("Searching for games...")
                        .tint(.secondaryRed)
                        .foregroundStyle(.secondaryRed)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(games) { game in
                                GameCard(game: game)
                                    .onTapGesture {
                                        gamesViewModel.selectGame(game)
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Games")
            .sheet(item: $gamesViewModel.selectedGame) { game in
                GameDetailView(game: game)
                    .onDisappear {
                        gamesViewModel.clearSelectedGame()
                    }
            }
        }
        .onAppear {
            gamesViewModel.fetchGames()
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("", text: $query)
                .tint(.secondaryRed)
                .placeholder("Search for a game", when: query.isEmpty) {
                    Text("Search for a game").foregroundStyle(.secondaryRed)
                }
                .onSubmit {
                    if !query.isEmpty {
                        gamesViewModel.searchGames(query: query)
                    }
                }
            
            if query.isEmpty {
                EmptyView()
            } else {
                Button(action: {
                    if gamesViewModel.isSearching {
                        // Não faz nada enquanto estiver buscando
                        return
                    }
                    
                    if !query.isEmpty {
                        // Se já tem texto, limpa a busca
                        query = ""
                        gamesViewModel.fetchGames()
                    } else {
                        // Se não tem texto, inicia busca de todos
                        gamesViewModel.fetchGames()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(
                            Circle()
                                .fill(.secondaryRed)
                        )
                }
            }
        }
        .foregroundStyle(.secondaryRed)
        .padding(10)
        .background(.primaryRed)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.horizontal)
    }
}


#Preview {
    ContentView()
        .environment(GamesViewModel())
}

// Extensão para criar um modificador de placeholder personalizado
extension View {
    func placeholder<Content: View>(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
