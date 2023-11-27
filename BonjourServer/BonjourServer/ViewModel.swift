//
//  ViewModel.swift
//  BonjourServerDemo
//
//  Created by max kryuchkov on 24.11.2023.
//

import Combine

final class ViewModel: ObservableObject {
    
    private let server: BonjourServer?
    @Published private(set) var isRunning: Bool = false
    
    init() {
        do {
            self.server = try BonjourServer()
        } catch {
            print(error)
            server = nil
        }
    }
    
    func start() {
        if isRunning {
            return
        }
        server?.start()
        isRunning = true
    }
    
    func stop() {
        server?.stop()
        isRunning = false
    }
}
