//
//  ContentView.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    
    var body: some View {
        Button("Fetch transactions") {
            Task {
                try await viewModel.fetch()
            }
        }
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView(viewModel: TransactionsListViewModel(
        transactionsService: ServiceAssembly.transactionsService
    ))
}
