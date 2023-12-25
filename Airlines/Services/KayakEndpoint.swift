//
//  KayakEndpoint.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import Foundation

/// Store Kayak Endpoints with URL
enum KayakEndpoint {
    case airlines
    case logo(String)
    
    private static let baseURL = "https://www.kayak.com"
    
    var url: URL? {
        switch self {
        case .airlines: return URL(string: KayakEndpoint.baseURL + "/h/mobileapis/directory/airlines")
        case .logo(let imageURL): return URL(string: KayakEndpoint.baseURL + imageURL)
        }
    }
}
