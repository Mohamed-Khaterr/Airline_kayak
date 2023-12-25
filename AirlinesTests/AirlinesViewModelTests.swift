//
//  AirlinesViewModelTests.swift
//  AirlinesTests
//
//  Created by Khater on 25/12/2023.
//

import XCTest
@testable import Airlines

final class AirlinesViewModelTests: XCTestCase {
    let viewModel = AirlinesViewModel(dbService: FavoriteAirlinesDB())
    
    func test_FavoriteSwitchToggle() {
        let dbService = FavoriteAirlinesDB()
        dbService.fetch()
        let favoriteAirlinesCount = dbService.favoriteAirlines.count
        
        let switchValue = true
        viewModel.favoriteSwitchStatus = { isOn in
            XCTAssertEqual(isOn, switchValue)
            XCTAssertEqual(switchValue ? favoriteAirlinesCount : 0, self.viewModel.numberOfRows)
        }
        
        viewModel.startShowFavorites(switchValue)
    }
}
