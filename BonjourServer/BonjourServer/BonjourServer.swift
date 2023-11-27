//
//  BonjourServer.swift
//  BonjourServerDemo
//
//  Created by max kryuchkov on 24.11.2023.
//

import Foundation
import Network

final class BonjourServer {

    private let listener: NWListener
    
    init() throws {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2
        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        parameters.allowLocalEndpointReuse = true
        listener = try NWListener(using: parameters, on: 15001)
        listener.service = NWListener.Service(name: "Demo Server", type: "_demoapp._tcp", domain: "local.")
    }

    func start() {
        listener.stateUpdateHandler = { newState in
            log("listener.stateUpdateHandler \(newState)")
        }
        listener.start(queue: .main)
    }
    
    func stop() {
        listener.cancel()
    }
}
