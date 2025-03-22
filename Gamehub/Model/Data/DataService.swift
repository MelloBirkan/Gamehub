//
//  DataService.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import Foundation

struct DataService {
    let apiKey: String = Bundle.main.infoDictionary?["API_KEY"] as! String
    
    func fetchGames() async -> FetchedGameList? {
        return nil
    }
}
