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
    
    func fetchGames() {
        Task {
            games = await self.service.fetchGames()
        }
    }
}
