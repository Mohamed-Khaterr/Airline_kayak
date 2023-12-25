//
//  AirlineDetailsViewModel.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import Foundation

class AirlineDetailsViewModel {
    private let dbService: FavoriteAirlinesDBProtocol
    private let airline: Airline
    private var isFavorite: Bool
    
    var showDetails: ((Airline) -> Void)?
    var favoriteStatus: ((Bool) -> Void)?
    var error: ((String) -> Void)?
    
    init(airline: Airline, dbService: FavoriteAirlinesDBProtocol) {
        self.airline = airline
        self.dbService = dbService
        dbService.fetch()
        isFavorite = dbService.favoriteAirlines.contains(airline)
    }
    
    func viewDidLoad() {
        showDetails?(airline)
        favoriteStatus?(isFavorite)
    }
    
    func changeAirlineFavoriteStatus() {
        if isFavorite {
            dbService.delete(airline)
        } else {
            dbService.save(airline)
        }
        
        isFavorite.toggle()
        favoriteStatus?(isFavorite)
    }
    
    func getAirlineWebsiteURL() -> URL? {
        return URL(string: airline.site)
    }
    
    func getAirlinePhoneNumberURL() -> URL? {
        let phoneNumber = airline.phone.replacingOccurrences(of: " ", with: "")
        return airline.phone.isEmpty ? nil : URL(string: "tel://\(phoneNumber)")
    }
}
