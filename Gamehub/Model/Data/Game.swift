//
//  Game.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import Foundation

struct Game: Decodable {
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
        case platforms
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
