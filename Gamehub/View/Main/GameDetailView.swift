//
//  GameDetailView.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 30/03/25.
//

import SwiftUI

struct GameDetailView: View {
    var game: Game
    @Environment(GamesViewModel.self) private var gamesViewModel
    @Environment(\.dismiss) var dismiss
    
    // Definindo colunas para grid com tamanhos iguais
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Imagem de fundo
                    ZStack(alignment: .top) {
                        // Imagem de fundo
                        AsyncImage(url: URL(string: game.backgroundImage ?? "")) { phase in
                            switch phase {
                            case .empty:
                                Rectangle()
                                    .fill(Color("SystemColor"))
                                    .aspectRatio(16/9, contentMode: .fill)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxHeight: 220)
                            case .failure:
                                Rectangle()
                                    .fill(Color("SystemColor"))
                                    .aspectRatio(16/9, contentMode: .fill)
                            @unknown default:
                                Rectangle()
                                    .fill(Color("SystemColor"))
                                    .aspectRatio(16/9, contentMode: .fill)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 220)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.1)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        // Botão para fechar o sheet
                        HStack {
                            Spacer()
                            
                            Button {
                                gamesViewModel.clearSelectedGame()
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                    }
                    
                    // Conteúdo principal
                    VStack(alignment: .leading, spacing: 24) {
                        // Título e avaliação
                        HStack {
                            Text(game.name ?? "Unknown Title")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("TextColor"))
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color("AccentColor"))
                                Text(String(format: "%.1f", game.rating))
                                    .font(.headline)
                                    .foregroundColor(Color("TextColor"))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color("AccentColor").opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Detalhes como plataformas e data de lançamento
                        HStack(spacing: 12) {
                            if !game.platformSymbols.isEmpty {
                                HStack(spacing: 8) {
                                    ForEach(game.platformSymbols, id: \.self) { symbol in
                                        Image(systemName: symbol)
                                            .foregroundColor(Color("ConnectPinkColor"))
                                    }
                                }
                                
                                Divider()
                                    .frame(height: 16)
                            }
                            
                            if let released = game.released {
                                Text(formatReleaseDate(released))
                                    .font(.subheadline)
                                    .foregroundColor(Color("TextColor").opacity(0.8))
                            }
                            
                            if let metacritic = game.metacritic, metacritic > 0 {
                                Spacer()
                                Text("\(metacritic)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(metacriticColor(score: metacritic))
                                    .cornerRadius(6)
                            }
                        }
                        
                        // Gêneros
                        if let genres = game.genres, !genres.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(genres, id: \.id) { genre in
                                        Text(genre.name ?? "")
                                            .font(.footnote)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color("SystemColor"))
                                            .foregroundColor(Color("TextColor"))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                        
                        // Classificação ESRB
                        if let esrbRating = game.esrbRating?.name {
                            HStack {
                                Text("Rating:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("TextColor"))
                                
                                Text(esrbRating)
                                    .font(.subheadline)
                                    .foregroundColor(Color("TextColor").opacity(0.8))
                                
                                Spacer()
                            }
                            
                            Divider()
                        }
                        
                        // Avaliações detalhadas
                        if let ratings = game.ratings, !ratings.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Ratings")
                                    .font(.headline)
                                    .foregroundColor(Color("TextColor"))
                                
                                ForEach(ratings, id: \.id) { rating in
                                    HStack {
                                        Text(rating.title ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(Color("TextColor"))
                                        
                                        Spacer()
                                        
                                        Text("\(rating.count ?? 0)")
                                            .font(.subheadline)
                                            .foregroundColor(Color("TextColor").opacity(0.8))
                                        
                                        Text("(\(Int(rating.percent ?? 0))%)")
                                            .font(.caption)
                                            .foregroundColor(Color("AccentColor"))
                                    }
                                    
                                    ProgressView(value: (rating.percent ?? 0) / 100)
                                        .tint(ratingColor(title: rating.title ?? ""))
                                }
                            }
                            
                            Divider()
                        }
                        
                        // Status de adição
                        if let addedByStatus = game.addedByStatus {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Player Status")
                                    .font(.headline)
                                    .foregroundColor(Color("TextColor"))
                                
                                // Grid para manter os cards do mesmo tamanho
                                LazyVGrid(columns: columns, spacing: 12) {
                                    if let playing = addedByStatus.playing, playing > 0 {
                                        playerStatusView(value: playing, title: "Playing", icon: "play.circle.fill")
                                    }
                                    
                                    if let beaten = addedByStatus.beaten, beaten > 0 {
                                        playerStatusView(value: beaten, title: "Completed", icon: "checkmark.circle.fill")
                                    }
                                    
                                    if let owned = addedByStatus.owned, owned > 0 {
                                        playerStatusView(value: owned, title: "Owned", icon: "person.fill")
                                    }
                                    
                                    if let toplay = addedByStatus.toplay, toplay > 0 {
                                        playerStatusView(value: toplay, title: "Want to Play", icon: "plusminus.circle.fill")
                                    }
                                    
                                    if let dropped = addedByStatus.dropped, dropped > 0 {
                                        playerStatusView(value: dropped, title: "Dropped", icon: "x.circle.fill")
                                    }
                                    
                                    if let yet = addedByStatus.yet, yet > 0 {
                                        playerStatusView(value: yet, title: "Not Yet", icon: "clock.fill")
                                    }
                                }
                            }
                            
                            Divider()
                        }
                        
                        // Estatísticas gerais
                        VStack(alignment: .leading, spacing: 12) {
                            Text("General Statistics")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                            
                            HStack {
                                statView(value: game.added ?? 0, title: "Added")
                                Divider()
                                    .frame(height: 40)
                                statView(value: game.playtime ?? 0, title: "Hours Played")
                                Divider()
                                    .frame(height: 40)
                                statView(value: game.ratingsCount ?? 0, title: "Ratings")
                            }
                            
                            if let updated = game.updated {
                                Text("Last updated: \(formatDate(updated))")
                                    .font(.caption)
                                    .foregroundColor(Color("TextColor").opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color.black.opacity(0.05))
    }
    
    // Função auxiliar para formatar a data de lançamento
    private func formatReleaseDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        
        return dateString
    }
    
    // Função geral para formatar datas
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
    
    // Função auxiliar para determinar a cor do Metacritic
    private func metacriticColor(score: Int) -> Color {
        if score >= 75 {
            return .green
        } else if score >= 50 {
            return .yellow
        } else {
            return .red
        }
    }
    
    // Função para cor de avaliação
    private func ratingColor(title: String) -> Color {
        switch title.lowercased() {
        case "exceptional":
            return Color("WelcomePurpleColor")
        case "recommended":
            return Color("DiscoverBlueColor")
        case "meh":
            return Color("ConnectPinkColor")
        case "skip":
            return .red
        default:
            return Color("AccentColor")
        }
    }
    
    // View auxiliar para mostrar estatísticas
    private func statView(value: Int, title: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)
                .foregroundColor(Color("AccentColor"))
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color("TextColor").opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
    
    // View auxiliar para status de jogador
    private func playerStatusView(value: Int, title: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color("AccentColor"))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                
                Text("\(value)")
                    .font(.caption)
                    .foregroundColor(Color("TextColor").opacity(0.6))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    GameDetailView(game: Game(
        id: 1,
        slug: "example-game",
        name: "The Witcher 3: Wild Hunt",
        released: "2015-05-19",
        tba: false,
        backgroundImage: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg",
        rating: 4.7,
        ratingTop: 5,
        ratings: [
            Rating(id: 1, title: "Exceptional", count: 3000, percent: 70.5),
            Rating(id: 2, title: "Recommended", count: 1500, percent: 20.0),
            Rating(id: 3, title: "Meh", count: 500, percent: 7.5),
            Rating(id: 4, title: "Skip", count: 100, percent: 2.0)
        ],
        ratingsCount: 5632,
        reviewsTextCount: 543,
        added: 18325,
        addedByStatus: AddedByStatus(
            yet: 450,
            owned: 12000,
            beaten: 3500,
            toplay: 800,
            dropped: 350,
            playing: 1200
        ),
        metacritic: 92,
        playtime: 45,
        suggestionsCount: 123,
        updated: "2023-04-10T12:30:45",
        esrbRating: ESRBRating(id: 4, slug: "mature", name: "Mature"),
        platforms: [
            PlatformElement(platform: Platform(id: 1, slug: "pc", name: "PC"), releasedAt: "2015-05-19", requirements: nil),
            PlatformElement(platform: Platform(id: 2, slug: "playstation4", name: "PlayStation 4"), releasedAt: "2015-05-19", requirements: nil),
            PlatformElement(platform: Platform(id: 3, slug: "xbox-one", name: "Xbox One"), releasedAt: "2015-05-19", requirements: nil)
        ],
        genres: [
            Genre(id: 4, name: "RPG", slug: "rpg", gamesCount: 1234, imageBackground: ""),
            Genre(id: 3, name: "Adventure", slug: "adventure", gamesCount: 1234, imageBackground: "")
        ]
    ))
    .environment(GamesViewModel())
}
