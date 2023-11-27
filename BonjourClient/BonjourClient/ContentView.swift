//
//  ContentView.swift
//  NetworkBonjourDemo
//
//  Created by max kryuchkov on 21.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var serviceType = "_demoapp._tcp"
    @State private var netDomain = "local."
    
    var body: some View {
        VStack {
            VStack {
                Text("Bonjour Browser Demo")
                    .fontWeight(.bold)
                TextField("Service Type", text: $serviceType)
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.isRunning)
                Text("Scan the local network, and list all devices of given type")
                    .font(.caption)
                
                HStack {
                    Button(action: {
                        if self.viewModel.isRunning {
                            self.viewModel.stop()
                        } else {
                            self.viewModel.start(serviceType: serviceType, serviceDomain: netDomain)
                        }
                    }, label: {
                        Text(self.viewModel.isRunning ? "Stop search" : "Search devices")
                    })
                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(self.viewModel.isRunning ? 1.0 : 0.0)
                        .padding(.horizontal, 10.0)
                }
                .padding(12)
                
                List {
                    ForEach(viewModel.items, id: \.self) { item in
                        VStack(alignment: .leading) {
                            Text(item.name).font(.subheadline)
                            Text("\(item.ipAddress):\(item.port)")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
