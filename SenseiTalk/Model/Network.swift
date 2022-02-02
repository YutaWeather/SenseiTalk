//
//  Network.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/02/02.
//

import Network

class Network {
    
    static let shared = Network()
    
    private let monitor = NWPathMonitor()
    
    func setUp() {
        
        monitor.pathUpdateHandler = { _ in
        }
        let queue = DispatchQueue(label: "Monitor")
        // ネットワーク監視開始
        monitor.start(queue: queue)
    }
    
    func isOnline() -> Bool {
        return monitor.currentPath.status == .satisfied
    }

}
