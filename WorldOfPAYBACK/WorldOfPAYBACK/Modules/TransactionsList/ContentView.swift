//
//  ContentView.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    @State private var categoryStatusBar: TransactionCategory = .all
    
    @State private var mainStack: [Transaction] = []
    
    var body: some View {
        NavigationStack(path: $mainStack) {
            Group {
                Picker("", selection: $categoryStatusBar) {
                    ForEach(TransactionCategory.allCases, id: \.categoryNumber) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: categoryStatusBar, perform: { value in
                    viewModel.updateSelectedCategory(value)
                })
                .padding()
                
                List(viewModel.transactionsToDisplay, id: \.id) { transaction in
                    NavigationLink(value: transaction) {
                        TransactionCellView(transaction: transaction)
                    }
                }
                
                Text(viewModel.sumToDisplay)
                    .font(.title)
                    .bold()
            }
            .navigationDestination(for: Transaction.self) { transaction in
                TransactionDetailsView(transaction: transaction)
            }
            .navigationTitle("Transactions List")
            .toolbar {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button {
                        Task {
                            try await viewModel.fetch()
                        }
                    } label: {
                        Text("Fetch")
                    }
                }
            }
            .alert("Fetching error", isPresented: $viewModel.isError, actions: {
                Button("OK", action: {})
            }, message: {})
        }
    }
}

struct TransactionCellView: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(transaction.partnerDisplayName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(transaction.amountLabel)
            }
            
            Text(transaction.descriptionLabel)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(transaction.dateLabel)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(String(transaction.category))
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContentView(viewModel: TransactionsListViewModel(
        transactionsService: ServiceAssembly.transactionsService
    ))
}
