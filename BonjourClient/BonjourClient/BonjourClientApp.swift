//
//  BonjourClientApp.swift
//  BonjourClient
//
//  Created by max kryuchkov on 26.11.2023.
//

import SwiftUI

@main
struct BonjourClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
