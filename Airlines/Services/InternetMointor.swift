//
//  InternetMointor.swift
//  Airlines
//
//  Created by Khater on 25/12/2023.
//

import Foundation
import Network

/// Class that Mointor internet changes
final class InternetMointor {
    static private let monitor = NWPathMonitor()
    static private let queue = DispatchQueue.global(qos: .background)
    
    static private var notification: ((Bool) -> Void)?
    static private(set) var isConnected = false
    
    private init () {}
    
    static func start() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            InternetMointor.isConnected = (path.status == .satisfied)
            //let message = (path.status == .satisfied) ? "Connected" : "Disconnected"
            //print("Internet is \(message)")
            InternetMointor.notification?(InternetMointor.isConnected)
        }
    }
    
    static func notify(connection: @escaping (Bool) -> Void) {
        notification = connection
    }
}
