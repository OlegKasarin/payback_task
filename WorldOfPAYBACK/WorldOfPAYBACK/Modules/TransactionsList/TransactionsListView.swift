//
//  TransactionsListView.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import SwiftUI

struct TransactionsListView: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    @State private var categoryStatusBar: TransactionCategory = .all
    
    @State private var mainStack: [PBTransaction] = []
    
    var body: some View {
        NavigationStack(path: $mainStack) {
            Group {
                Picker("", selection: $categoryStatusBar) {
                    ForEach(TransactionCategory.allCases, id: \.categoryNumber) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                .padding()
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: categoryStatusBar, perform: { value in
                    viewModel.updateSelectedCategory(value)
                })
                
                List(viewModel.transactionsSections, id: \.date) { section in
                    sectionFor(section: section)
                }
                
                sumView(sum: viewModel.sumToDisplay)
            }
            .navigationDestination(for: PBTransaction.self) { transaction in
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
    
    private func sectionFor(section: TransactionsSection) -> some View {
        Section {
            ForEach(section.transactions) { transaction in
                NavigationLink(value: transaction) {
                    TransactionCellView(transaction: transaction)
                }
            }
        } header: {
            Text(section.titleLabel)
        }
    }
    
    private func sumView(sum: String) -> some View {
        Text(sum)
            .font(.title)
            .bold()
    }
}

struct TransactionCellView: View {
    let transaction: PBTransaction
    
    var body: some View {
        HStack {
            Text(String(transaction.category))
                .font(.callout)
                .bold()
                .padding()
            
            VStack(spacing: 8) {
                HStack {
                    Text(transaction.partnerDisplayName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(transaction.amountLabel)
                }
                
                if let description = transaction.description {
                    Text(description)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(transaction.timeLabel)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    TransactionsListView(viewModel: TransactionsListViewModel(
        transactionsService: ServiceAssembly.transactionsService
    ))
}
