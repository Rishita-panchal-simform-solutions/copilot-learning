//
//  ReachabilityManager.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Connectivity
import SwiftUI
class ReachabilityManager: ObservableObject {
    // MARK: - Variables
    static let shared = ReachabilityManager()
    private(set) var connectivity = Connectivity()
    @Published var isNetworkReachable = true
    
    // MARK: - Initializer
    init() {
        connectivity.startNotifier()
        let connectivityChanged: (Connectivity) -> Void = { [weak self] connectivity in
            connectivity.checkConnectivity { connectivity in
                guard let self else { return }
                switch connectivity.status {
                case .connected,
                        .connectedViaWiFi,
                        .connectedViaEthernet,
                        .connectedViaCellular:
                    self.isNetworkReachable = true
                default:
                    self.isNetworkReachable = false
                }
            }
        }
        connectivity.whenConnected = connectivityChanged
        connectivity.whenDisconnected = connectivityChanged
        connectivity.isPollingEnabled = true
    }
}