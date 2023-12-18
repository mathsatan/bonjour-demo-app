//
//  ContentView.swift
//  BonjourServer
//
//  Created by max kryuchkov on 26.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Bonjour Server Demo")
            Button("Stop") {
                viewModel.stop()
            }
        }
        .padding()
        .onAppear {
            viewModel.start()
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
