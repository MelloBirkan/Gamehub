//
//  GameCard.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 30/03/25.
//

import SwiftUI

struct GameCard: View {
    let game: Game
    @State private var isHovering = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // Card background with gradient
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
                .frame(width: 180, height: 240)
                .shadow(color: Color("AccentColor").opacity(0.1), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 8) {
                gameImage
                gameInfo
            }
        }
        .scaleEffect(isHovering ? 1.03 : 1.0)
        .animation(.spring(response: 0.3), value: isHovering)
        .onHoverEffect { hovering in
            isHovering = hovering
        }
    }
    
    private var gameImage: some View {
        GeometryReader { geometry in
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
                            .overlay(
                                ProgressView()
                                    .tint(Color.white)
                            )
                    
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            .clipped()
                    
                    case .failure:
                        Rectangle()
                            .fill(Color("SystemColor"))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(Color("TextColor").opacity(0.3))
                            )
                    
                    @unknown default:
                        EmptyView()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.5),
                        Color.black.opacity(0.0)
                    ]),
                    startPoint: .top,
                    endPoint: .center
                )
            )
        }
        .frame(width: 180, height: 145)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 16
            )
        )
    }
    
    private var gameInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(game.name ?? "No name")
                .lineLimit(1)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, Color.white.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text(formattedReleaseDate)
                .font(.caption)
                .foregroundStyle(Color.white.opacity(0.7))
            
            HStack {
                // Rating
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                    Text(String(format: "%.1f", game.rating))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color("AccentColor"), Color("AccentColor").opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color("AccentColor").opacity(0.2))
                )
                
                Spacer()
                
                // Platform icons
                HStack(spacing: 4) {
                    ForEach(game.platformSymbols.prefix(3), id: \.self) { symbol in
                        Image(systemName: symbol)
                            .font(.system(size: 10))
                            .foregroundStyle(Color("ConnectPinkColor"))
                    }
                    
                    if game.platformSymbols.count > 3 {
                        Text("+\(game.platformSymbols.count - 3)")
                            .font(.system(size: 8))
                            .foregroundStyle(Color("ConnectPinkColor"))
                    }
                }
            }
        }
        .frame(width: 156)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
    
    private var formattedReleaseDate: String {
        guard let releasedString = game.released, !releasedString.isEmpty else {
            return "No release date"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releasedString) else {
            return releasedString
        }
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
}

// Extensão para o efeito de hover
extension View {
    func onHoverEffect(_ perform: @escaping (Bool) -> Void) -> some View {
        self
    #if os(macOS)
            .onHover(perform: perform)
    #else
            // No-op para iOS
    #endif
    }
}

//#Preview {
//    GameCard(game: Game)
//}
