//
//  GameListViewModel.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import Foundation
import Observation

@Observable
class GamesViewModel {
    let service = DataService()
    var games = [Game]()
    var isSearching = false
    
    func fetchGames() {
        Task {
            games = await self.service.fetchGamesData()
        }
    }
    
    func searchGames(query: String) {
        isSearching = true
        
        Task {
            games = await self.service.fetchGamesData(dates: nil, platforms: nil, search: query)
            isSearching = false
        }
    }
}
