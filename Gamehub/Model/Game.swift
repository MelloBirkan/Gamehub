//
//  Game.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import Foundation

struct Game: Decodable, Identifiable {
    let id: Int?
    let slug: String?
    let name: String?
    let released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double
    let ratingTop: Int?
    let ratings: [Rating]?
    let ratingsCount: Int?
    let reviewsTextCount: Int?
    let added: Int?
    let addedByStatus: AddedByStatus?
    let metacritic: Int?
    let playtime: Int?
    let suggestionsCount: Int?
    let updated: String?
    let esrbRating: ESRBRating?
    let platforms: [PlatformElement]?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case esrbRating = "esrb_rating"
        case platforms, genres
    }
    
    var platformSymbols: [String] {
        guard let platforms = platforms else { return [] }
        
        var symbols: [String] = []
        
        for platformElement in platforms {
            guard let platform = platformElement.platform else { continue }
            guard let slug = platform.slug?.lowercased() else { continue }
            
            if slug.contains("playstation") || slug.contains("ps") {
                symbols.append("playstation.logo")
            } else if slug.contains("xbox") {
                symbols.append("xbox.logo")
            } else if slug.contains("pc") || slug.contains("windows") {
                symbols.append("desktopcomputer")
            } else if slug.contains("mac") || slug.contains("apple") {
                symbols.append("apple.logo")
            }  else if slug.contains("ios") || slug.contains("iphone") {
                symbols.append("iphone")
            } 
        }
        
        // Remove duplicates
        return Array(Set(symbols))
    }
}

struct Rating: Decodable {
    let id: Int?
    let title: String?
    let count: Int?
    let percent: Double?
}

struct AddedByStatus: Decodable {
    let yet: Int?
    let owned: Int?
    let beaten: Int?
    let toplay: Int?
    let dropped: Int?
    let playing: Int?
}

struct ESRBRating: Decodable {
    let id: Int?
    let slug: String?
    let name: String?
}

struct PlatformElement: Decodable {
    let platform: Platform?
    let releasedAt: String?
    let requirements: Requirements?
    
    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

struct Platform: Decodable {
    let id: Int?
    let slug: String?
    let name: String?
}

struct Requirements: Decodable {
    let minimum: String?
    let recommended: String?
}

struct Genre: Decodable {
    let id: Int?
    let name: String?
    let slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
