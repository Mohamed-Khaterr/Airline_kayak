//
//  FavoriteAirlinesDBProtocol.swift
//  Airlines
//
//  Created by Khater on 25/12/2023.
//

import Foundation

/// Interface for Favorite Airlines Casching
protocol FavoriteAirlinesDBProtocol {
    var favoriteAirlines: [Airline] { get }
    
    func fetch()
    func save(_ airline: Airline)
    func delete(_ airline: Airline)
}
