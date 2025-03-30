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
    @State private var animateGradient = false
    
    var body: some View {
        @Bindable var gamesViewModel = gamesViewModel
        let games = gamesViewModel.games
        
        NavigationStack {
            ZStack {
                // Fundo com gradiente animado
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("BackgroudnColor"), 
                        Color.black.opacity(0.9)
                    ]),
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea()
                .animation(Animation.easeInOut(duration: 10.0).repeatForever(autoreverses: true), value: animateGradient)
                .onAppear { animateGradient = true }
                
                // Conteúdo principal
                VStack(spacing: 16) {
                    // Logo animado
                    Text("GAMEHUB")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color("AccentColor"), Color("SecondaryPurpleColor")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.top, 20)
                        .shadow(color: Color("AccentColor").opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    searchBar
                    
                    if gamesViewModel.isSearching {
                        Spacer()
                        VStack(spacing: 16) {
                            ProgressView()
                                .tint(Color("DiscoverBlueColor"))
                                .scaleEffect(1.5)
                            
                            Text("Buscando jogos...")
                                .font(.headline)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color("DiscoverBlueColor"), Color("DiscoverBlueColor").opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.4))
                                .padding()
                        )
                        Spacer()
                    } else if games.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color("WelcomePurpleColor").opacity(0.7))
                            
                            Text("Nenhum jogo encontrado")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(games) { game in
                                    GameCard(game: game)
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                                gamesViewModel.selectGame(game)
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 20)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $gamesViewModel.selectedGame) { game in
                GameDetailView(game: game)
                    .onDisappear {
                        gamesViewModel.clearSelectedGame()
                    }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            gamesViewModel.fetchGames()
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
            
            TextField("", text: $query)
                .font(.system(size: 16))
                .tint(Color("DiscoverBlueColor"))
                .placeholder("Buscar jogos", when: query.isEmpty) {
                    Text("Buscar jogos")
                        .font(.system(size: 16))
                        .foregroundStyle(Color("DiscoverBlueColor").opacity(0.8))
                }
                .submitLabel(.search)
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
                        return
                    }
                    
                    if !query.isEmpty {
                        withAnimation {
                            query = ""
                            gamesViewModel.fetchGames()
                        }
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color("WelcomePurpleColor"), Color("WelcomePurpleColor").opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .foregroundStyle(Color("DiscoverBlueColor"))
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("BackgroudnColor").opacity(0.7),
                            Color("BackgroudnColor").opacity(0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

// Efeito de escala para botões
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
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
