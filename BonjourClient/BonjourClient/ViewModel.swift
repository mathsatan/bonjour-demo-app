//
//  ViewModel.swift
//  NetworkBonjourDemo
//
//  Created by max kryuchkov on 23.11.2023.
//

import Foundation
import Combine
import Network

final class ViewModel: ObservableObject {
    
    @Published var items: [ServiceInfo] = []
    @Published  private(set) var isRunning: Bool = false
    
    private lazy var serviceBrowser: NetworkBrowserService = {
        return NetworkBrowserService(didReceiveUpdate: { update in
            switch update {
            case .success(let services):
                self.items = services.map { self.map(service: $0) }
            case .failure(let error):
                print(error)
            }
        })
    }()
    
    func start(serviceType: String, serviceDomain: String) {
        self.serviceBrowser.startSearch(typeOf: serviceType, domain: serviceDomain)
        self.isRunning = true
    }
    
    func stop() {
        self.serviceBrowser.stopScan()
        self.isRunning = false
    }
}

// MARK: - Private methods

private extension ViewModel {
    
    func map(service: NetService) -> ServiceInfo {
        let ipAddresses = service.addresses?.compactMap { $0.toIP } ?? []
        return .init(name: service.name, ipAddress: ipAddresses.first ?? "N/A", port: String(service.port))
    }
}
