//
//  AirlinesViewModel.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import Foundation
import Alamofire


class AirlinesViewModel {
    private let dbService: FavoriteAirlinesDBProtocol
    private var cache: [Airline]? = nil
    private var airlines = [Airline]() {
        didSet {
            self.reload?()
        }
    }
    private var isFavoriteSwitchOn = false {
        didSet {
            if isFavoriteSwitchOn {
                cache = airlines
                airlines = dbService.favoriteAirlines
            } else {
                airlines = cache ?? []
                cache = nil
            }
        }
    }
    
    init(dbService: FavoriteAirlinesDBProtocol) {
        self.dbService = dbService
    }
    
    
    var reload: (() -> Void)?
    var isLoading: ((Bool) -> Void)?
    var error: ((String) -> Void)?
    var favoriteSwitchStatus: ((Bool) -> Void)?
    
    var numberOfRows: Int { airlines.count }
    
    func config(_ cell: AirlineCell, at index: Int) {
        let airline = airlines[index]
        cell.showInfo(of: airline)
    }
    
    func airline(at index: Int) -> Airline {
        return airlines[index]
    }
    
    func viewWillAppear() {
        if isFavoriteSwitchOn {
            dbService.fetch()
            airlines = dbService.favoriteAirlines
            reload?()
        }
    }
    
    func getAirlines() {
        if InternetMointor.isConnected {
            fetchAirlinesFromAPI()
        } else {
            startShowFavorites(true)
        }
    }
    
    func startShowFavorites(_ isFavoriteShow: Bool) {
        dbService.fetch()
        self.isFavoriteSwitchOn = isFavoriteShow
        favoriteSwitchStatus?(isFavoriteShow)
    }
    
    private func fetchAirlinesFromAPI() {
        guard let url = KayakEndpoint.airlines.url else { return }
        isLoading?(true)
        AF.request(url).responseDecodable(of: [Airline].self, queue: DispatchQueue.main) { [weak self] reponse in
            self?.isLoading?(false)
            switch reponse.result {
            case .success(let airlines):
                self?.airlines = airlines
            case .failure(let error):
                self?.error?(error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        if isFavoriteSwitchOn {
            dbService.fetch()
            isLoading?(false)
        } else {
            fetchAirlinesFromAPI()
        }
    }
}
