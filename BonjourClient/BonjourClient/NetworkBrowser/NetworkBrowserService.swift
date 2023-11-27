//
//  NetworkBrowserService.swift
//  NetworkBonjourDemo
//
//  Created by max kryuchkov on 21.11.2023.
//

import Foundation
import Network

final class NetworkBrowserService: NSObject {
    
    private var netServiceBrowser: NetServiceBrowser?
    private var services = [NetService]()
    private let didReceiveUpdate: (Result<[NetService], Error>) -> Void
    
    init(netServiceBrowser: NetServiceBrowser? = nil,
         items: [NetService] = [],
         didReceiveUpdate: @escaping (Result<[NetService], Error>) -> Void) {
        self.netServiceBrowser = netServiceBrowser
        self.services = items
        self.didReceiveUpdate = didReceiveUpdate
    }
    
    func startSearch(typeOf: String, domain: String = "local.") {
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser?.delegate = self
        netServiceBrowser?.searchForServices(ofType: typeOf, inDomain: domain)
    }
    
    func stopScan() {
        self.netServiceBrowser?.stop()
        self.services.forEach { $0.stop() }
        self.services.removeAll()
        self.netServiceBrowser = nil
    }
}

// MARK: - NetServiceDelegate

extension NetworkBrowserService: NetServiceDelegate {
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        self.updateInterface()
        self.didReceiveUpdate(.success(self.services))
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        let code = (errorDict[NetService.errorCode]?.intValue).flatMap { NetService.ErrorCode(rawValue: $0) } ?? .unknownError
        let error = NSError(domain: NetService.errorDomain, code: code.rawValue, userInfo: nil)
        self.didReceiveUpdate(.failure(error))
    }
}

// MARK: - NetServiceBrowserDelegate

extension NetworkBrowserService: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didFind aNetService: NetService, moreComing: Bool) {
        self.services.append(aNetService)
        if moreComing {
            return
        }
        self.updateInterface()
        self.didReceiveUpdate(.success(self.services))
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NetServiceBrowser, didRemove aNetService: NetService, moreComing: Bool) {
        if let index = self.services.firstIndex(of: aNetService) {
            self.services.remove(at: index)
            self.didReceiveUpdate(.success(self.services))
        }
    }
}

// MARK: - Private methods

private extension NetworkBrowserService {
    
    func updateInterface() {
        for item in self.services where item.port == -1 {
            item.delegate = self
            item.resolve(withTimeout: 10)
        }
    }
}
