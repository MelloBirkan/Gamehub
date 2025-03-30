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
    
    var body: some View {
        VStack(spacing: 0) {
            // Indicador de arraste para o sheet
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
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
                    
                    // Informações do jogo
                    VStack(alignment: .leading, spacing: 16) {
                        // Título e avaliação
                        HStack {
                            Text(game.name ?? "Título desconhecido")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("TextColor"))
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color("PrimaryRedColor"))
                                Text(String(format: "%.1f", game.rating))
                                    .font(.headline)
                                    .foregroundColor(Color("TextColor"))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color("PrimaryRedColor").opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Detalhes como plataformas e data de lançamento
                        HStack(spacing: 12) {
                            if !game.platformSymbols.isEmpty {
                                HStack(spacing: 8) {
                                    ForEach(game.platformSymbols, id: \.self) { symbol in
                                        Image(systemName: symbol)
                                            .foregroundColor(Color("SecondaryRedColor"))
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
                        
                        // Classificação ESRB
                        if let esrbRating = game.esrbRating?.name {
                            HStack {
                                Text("Classificação:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("TextColor"))
                                
                                Text(esrbRating)
                                    .font(.subheadline)
                                    .foregroundColor(Color("TextColor").opacity(0.8))
                                
                                Spacer()
                            }
                        }
                        
                        Divider()
                        
                        // Estatísticas
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Estatísticas")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                            
                            HStack {
                                statView(value: game.added ?? 0, title: "Adicionados")
                                Divider()
                                    .frame(height: 40)
                                statView(value: game.playtime ?? 0, title: "Horas jogadas")
                                Divider()
                                    .frame(height: 40)
                                statView(value: game.ratingsCount ?? 0, title: "Avaliações")
                            }
                        }
                        
                        Divider()
                        
                        // Botão para jogar ou comprar
                        Button {
                            // Ação para comprar ou jogar
                        } label: {
                            HStack {
                                Spacer()
                                Text("JOGAR AGORA")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color("PrimaryRedColor"))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color("BackgroudnColor"))
    }
    
    // Função auxiliar para formatar a data de lançamento
    private func formatReleaseDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    // Função auxiliar para determinar a cor do Metacritic
    private func metacriticColor(score: Int) -> Color {
        if score >= 75 {
            return Color.green
        } else if score >= 50 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
    
    // View auxiliar para mostrar estatísticas
    private func statView(value: Int, title: String) -> some View {
        VStack {
            Text("\(value)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryRedColor"))
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color("TextColor").opacity(0.8))
        }
        .frame(maxWidth: .infinity)
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
        ratings: [],
        ratingsCount: 5632,
        reviewsTextCount: 543,
        added: 18325,
        addedByStatus: nil,
        metacritic: 92,
        playtime: 45,
        suggestionsCount: 123,
        updated: "2023-04-10",
        esrbRating: ESRBRating(id: 4, slug: "mature", name: "Mature"),
        platforms: [],
        genres: [
            Genre(id: 4, name: "RPG", slug: "rpg", gamesCount: 1234, imageBackground: ""),
            Genre(id: 3, name: "Aventura", slug: "adventure", gamesCount: 1234, imageBackground: "")
        ]
    ))
    .environment(GamesViewModel())
}
