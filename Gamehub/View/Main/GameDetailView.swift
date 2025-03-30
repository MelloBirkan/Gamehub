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
    @State private var animateContent = false
    @State private var showDescription = false
    
    // Definindo colunas para grid com tamanhos iguais
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("BackgroudnColor"),
                    Color.black.opacity(0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Background image
                        ZStack(alignment: .top) {
                            // Background image
                            AsyncImage(url: URL(string: game.backgroundImage ?? "")) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color("WelcomePurpleColor").opacity(0.3), Color("DiscoverBlueColor").opacity(0.3)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .aspectRatio(16/9, contentMode: .fill)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxHeight: 250)
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
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .clipped()
                            .overlay(
                                // Gradiente de sobreposição para melhorar contraste
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.7),
                                        Color.black.opacity(0.5),
                                        Color.black.opacity(0.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            
                            // Title overlaid on image
                            VStack {
                                // Button to close sheet
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        withAnimation {
                                            gamesViewModel.clearSelectedGame()
                                            dismiss()
                                        }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(
                                                Circle()
                                                    .fill(Color.black.opacity(0.5))
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                                    )
                                            )
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                                .padding()
                                
                                Spacer()
                                
                                // Title and rating
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(game.name ?? "Unknown Title")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                                    
                                    HStack {
                                        // Platforms
                                        if !game.platformSymbols.isEmpty {
                                            HStack(spacing: 8) {
                                                ForEach(game.platformSymbols, id: \.self) { symbol in
                                                    Image(systemName: symbol)
                                                        .foregroundColor(Color("ConnectPinkColor"))
                                                }
                                            }
                                            
                                            Divider()
                                                .frame(height: 16)
                                                .background(Color.white.opacity(0.3))
                                        }
                                        
                                        // Release date
                                        if let released = game.released {
                                            Text(formatReleaseDate(released))
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        
                                        Spacer()
                                        
                                        // Metacritic
                                        if let metacritic = game.metacritic, metacritic > 0 {
                                            Text("\(metacritic)")
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .fill(metacriticColor(score: metacritic))
                                                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                                .background(
                                    // Gradiente para o título
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.black.opacity(0.0),
                                            Color.black.opacity(0.6)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                        }
                        
                        // Featured rating
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color("AccentColor").opacity(0.8),
                                                Color("AccentColor").opacity(0.4)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.white.opacity(0.5),
                                                        Color.white.opacity(0.2),
                                                        Color.clear
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: Color("AccentColor").opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                VStack(spacing: 0) {
                                    Text(String(format: "%.1f", game.rating))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    HStack(spacing: 1) {
                                        ForEach(0..<5) { i in
                                            Image(systemName: i < Int(game.rating) ? "star.fill" : "star")
                                                .font(.system(size: 8))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Player Ratings")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("\(game.ratingsCount ?? 0) ratings")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
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
                                    RoundedRectangle(cornerRadius: 16)
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
                        )
                        .offset(y: -20)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            // Genres
                            if let genres = game.genres, !genres.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(genres, id: \.id) { genre in
                                            Text(genre.name ?? "")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    Capsule()
                                                        .fill(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [
                                                                    Color("WelcomePurpleColor").opacity(0.8),
                                                                    Color("WelcomePurpleColor").opacity(0.5)
                                                                ]),
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            )
                                                        )
                                                        .overlay(
                                                            Capsule()
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
                                                )
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                            
                            // Classificação ESRB
                            if let esrbRating = game.esrbRating?.name {
                                HStack {
                                    Text("Classificação:")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Text(esrbRating)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Color("DiscoverBlueColor").opacity(0.3))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(Color("DiscoverBlueColor").opacity(0.5), lineWidth: 1)
                                                )
                                        )
                                    
                                    Spacer()
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                            }
                            
                            // Detailed ratings
                            if let ratings = game.ratings, !ratings.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Ratings")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    ForEach(ratings, id: \.id) { rating in
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text(rating.title ?? "")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                                
                                                Text("\(rating.count ?? 0)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white.opacity(0.8))
                                                
                                                Text("(\(Int(rating.percent ?? 0))%)")
                                                    .font(.caption)
                                                    .foregroundColor(ratingColor(title: rating.title ?? ""))
                                            }
                                            
                                            // Barra de progresso personalizada
                                            GeometryReader { geometry in
                                                ZStack(alignment: .leading) {
                                                    // Fundo
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(Color.white.opacity(0.1))
                                                        .frame(height: 8)
                                                    
                                                    // Progresso
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [
                                                                    ratingColor(title: rating.title ?? ""),
                                                                    ratingColor(title: rating.title ?? "").opacity(0.7)
                                                                ]),
                                                                startPoint: .leading,
                                                                endPoint: .trailing
                                                            )
                                                        )
                                                        .frame(width: geometry.size.width * CGFloat(rating.percent ?? 0) / 100, height: 8)
                                                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: animateContent)
                                                }
                                            }
                                            .frame(height: 8)
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.black.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                            }
                            
                            // Status de adição
                            if let addedByStatus = game.addedByStatus {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Status dos Jogadores")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    // Grid para manter os cards do mesmo tamanho
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        if let playing = addedByStatus.playing, playing > 0 {
                                            playerStatusView(value: playing, title: "Jogando", icon: "play.circle.fill", color: Color("DiscoverBlueColor"))
                                        }
                                        
                                        if let beaten = addedByStatus.beaten, beaten > 0 {
                                            playerStatusView(value: beaten, title: "Completo", icon: "checkmark.circle.fill", color: Color("WelcomePurpleColor"))
                                        }
                                        
                                        if let owned = addedByStatus.owned, owned > 0 {
                                            playerStatusView(value: owned, title: "Possui", icon: "person.fill", color: Color("ConnectPinkColor"))
                                        }
                                        
                                        if let toplay = addedByStatus.toplay, toplay > 0 {
                                            playerStatusView(value: toplay, title: "Quer Jogar", icon: "plusminus.circle.fill", color: Color("AccentColor"))
                                        }
                                        
                                        if let dropped = addedByStatus.dropped, dropped > 0 {
                                            playerStatusView(value: dropped, title: "Abandonou", icon: "x.circle.fill", color: Color.red)
                                        }
                                        
                                        if let yet = addedByStatus.yet, yet > 0 {
                                            playerStatusView(value: yet, title: "Pendente", icon: "clock.fill", color: Color("SecondaryPurpleColor"))
                                        }
                                    }
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                            }
                            
                            // Estatísticas gerais
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Estatísticas Gerais")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 0) {
                                    statView(value: game.added ?? 0, title: "Adicionado", icon: "plus.circle.fill", color: Color("WelcomePurpleColor"))
                                    
                                    Divider()
                                        .frame(height: 40)
                                        .background(Color.white.opacity(0.2))
                                    
                                    statView(value: game.playtime ?? 0, title: "Horas Jogadas", icon: "clock.fill", color: Color("DiscoverBlueColor"))
                                    
                                    Divider()
                                        .frame(height: 40)
                                        .background(Color.white.opacity(0.2))
                                    
                                    statView(value: game.ratingsCount ?? 0, title: "Ratings", icon: "star.fill", color: Color("ConnectPinkColor"))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.black.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                
                                if let updated = game.updated {
                                    Text("Última atualização: \(formatDate(updated))")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .offset(y: -10)
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animateContent = true
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Helper Functions
    
    private func formatReleaseDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        
        return dateString
    }
    
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
    
    private func metacriticColor(score: Int) -> Color {
        if score >= 75 {
            return .green
        } else if score >= 50 {
            return .yellow
        } else {
            return .red
        }
    }
    
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
    
    // MARK: - Views Helpers
    
    private func statView(value: Int, title: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text("\(value)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
    
    private func playerStatusView(value: Int, title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                
                Text("\(value)")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.5),
                            Color.black.opacity(0.3)
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
                                    color.opacity(0.5),
                                    color.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
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
