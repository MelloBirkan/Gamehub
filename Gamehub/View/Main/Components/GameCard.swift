//
//  GameCard.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 30/03/25.
//

import SwiftUI

struct GameCard: View {
    let game: Game
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 180, height: 220)
                .foregroundStyle(Color("SystemColor"))
            
            VStack(alignment: .leading, spacing: 5) {
                gameImage
                gameInfo
            }
        }
    }
    
    private var gameImage: some View {
        AsyncImage(url: URL(string: game.backgroundImage ?? "")) { phase in
            switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    let roundedShape = UnevenRoundedRectangle(
                        topLeadingRadius: 8,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 8,
                        style: .continuous
                    )
                    
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 145)
                        .clipShape(roundedShape)
                    
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180)
                @unknown default:
                    EmptyView()
            }
        }
    }
    
    private var gameInfo: some View {
        Group {
            Text(game.name ?? "No name")
                .lineLimit(1)
                .font(.headline)
                .foregroundStyle(.text)
            
            Text(formattedReleaseDate)
                .font(.caption)
                .foregroundStyle(Color.secondary)
            
            HStack {
                Label((game.rating).description, systemImage: "star.fill")
                    .foregroundStyle(.primaryRed)
                    .font(.caption2)
                
                Spacer()
                
                HStack(spacing: 1) {
                    ForEach(game.platformSymbols, id: \.self) { symbol in
                        Image(systemName: symbol)
                            .font(.caption2)
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 8)
    }
    
    private var formattedReleaseDate: String {
        guard let releasedString = game.released, !releasedString.isEmpty else {
            return "Sem data de lançamento"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releasedString) else {
            return releasedString
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

//#Preview {
//    GameCard(game: Game)
//}
