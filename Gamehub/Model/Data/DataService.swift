//
//  DataService.swift
//  Gamehub
//
//  Created by Marcello Gonzatto Birkan on 22/03/25.
//

import Foundation

struct DataService {
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    func fetchGamesData(dates: String? = nil, platforms: String? = nil, search: String? = nil) async -> [Game] {
        guard let apiKey else {
            print("API key not found in Info.plist")
            return []
        }
        
        let endpoint = "https://api.rawg.io/api/games"
        
        // Construir URL com a API key como parâmetro conforme documentação
        var components = URLComponents(string: endpoint)
        
        // Iniciar com o item de consulta obrigatório (API key)
        var queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        // Adicionar parâmetros opcionais se fornecidos
        if let dates = dates {
            queryItems.append(URLQueryItem(name: "dates", value: dates))
        }
        
        if let platforms = platforms {
            queryItems.append(URLQueryItem(name: "platforms", value: platforms))
        }
        
        if let search = search {
            // Substituir espaços por caracteres de consulta apropriados
            let formattedSearch = search.replacingOccurrences(of: " ", with: "+")
            queryItems.append(URLQueryItem(name: "search", value: formattedSearch))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            print("Could not create URL")
            return []
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 
                  httpResponse.statusCode == 200 else {
                print("Error in server response")
                return []
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(FetchedGameList.self, from: data)
            return result.results
        } catch {
            print("Error fetching games: \(error)")
            return []
        }
    }
}
