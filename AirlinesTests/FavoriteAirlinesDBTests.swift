//
//  FavoriteAirlinesDBTests.swift
//  AirlinesTests
//
//  Created by Khater on 25/12/2023.
//

import XCTest
@testable import Airlines

final class FavoriteAirlinesDBTests: XCTestCase {
    let dbService: FavoriteAirlinesDBProtocol = FavoriteAirlinesDB()
    private let MOCK_AIRLIENS = [
        Airline(name: "First Airline", phone: "012033", logoURL: "/first/airline", site: "airline1.com"),
        Airline(name: "Second Airline", phone: "0123456", logoURL: "/second/airline", site: "airline2.com"),
        Airline(name: "Third Airline", phone: "0435345", logoURL: "/third/airline", site: "airline3.com"),
        Airline(name: "Fourth Airline", phone: "845845", logoURL: "/fourth/airline", site: "airline4.com"),
    ]
    
    func test_saveAirlineToFavoritesDB() {
        dbService.fetch()
        var currentLength = dbService.favoriteAirlines.count
        
        if dbService.favoriteAirlines.contains(MOCK_AIRLIENS[0]) {
            dbService.delete(MOCK_AIRLIENS[0])
            currentLength -= 1
        }

        
        dbService.save(MOCK_AIRLIENS[0])
        XCTAssert(dbService.favoriteAirlines.contains(MOCK_AIRLIENS[0]))
        currentLength += 1
        XCTAssertEqual(dbService.favoriteAirlines.count, currentLength)
        
        dbService.save(MOCK_AIRLIENS[0])
        XCTAssert(dbService.favoriteAirlines.contains(MOCK_AIRLIENS[0]))
        XCTAssertEqual(dbService.favoriteAirlines.count, currentLength)
        
        
        
        let test = dbService.favoriteAirlines.filter({ $0 == MOCK_AIRLIENS[0] })
        XCTAssertEqual(test.count, 1)
    }
    
    func test_deleteAirlineFromFavoritesDB() {
        dbService.fetch()
        
        var currentLength = dbService.favoriteAirlines.count
        
        if !dbService.favoriteAirlines.contains(MOCK_AIRLIENS[3]) {
            dbService.save(MOCK_AIRLIENS[3])
            currentLength += 1
        }
        
        dbService.delete(MOCK_AIRLIENS[3])
        
        currentLength -= 1
        
        dbService.delete(MOCK_AIRLIENS[3])
        
        XCTAssertEqual(dbService.favoriteAirlines.count, currentLength)
        XCTAssertFalse(dbService.favoriteAirlines.contains(MOCK_AIRLIENS[3]))
        
        let test = dbService.favoriteAirlines.filter({ $0 == MOCK_AIRLIENS[3] })
        XCTAssertEqual(test.count, 0)
    }
}
