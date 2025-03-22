//
//  FetchedGameList.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import Foundation

struct FetchedGameList: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}
