//
//  Airline.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import Foundation

struct Airline: Decodable, Equatable, Hashable {
    let name: String
    let phone: String
    let logoURL: String
    let site: String
}
