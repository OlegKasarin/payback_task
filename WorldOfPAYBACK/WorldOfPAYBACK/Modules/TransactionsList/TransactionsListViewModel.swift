//
//  TransactionsListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

final class TransactionsListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var selectedCategory: TransactionCategory = .all
    
    @Published var isLoading = false
    @Published var isError = false
    
    private let transactionsService: TransactionsServiceProtocol
    
    var transactionsToDisplay: [Transaction] {
        switch selectedCategory {
        case .all:
            return transactions
        case .first, .second:
            return transactions.filter { $0.category == selectedCategory.categoryNumber }
        }
    }
    
    init(transactionsService: TransactionsServiceProtocol) {
        self.transactionsService = transactionsService
    }
    
    @MainActor
    func fetch() async throws {
        isLoading = true
        do {
            let transactions = try await transactionsService.fetchMocked() 
            let sortedTransactions = transactions.sorted(by: { $0.bookingDate > $1.bookingDate })
            
            isLoading = false
            self.transactions = sortedTransactions
        } catch {
            isLoading = false
            isError = true
//            transactions = []
        }
    }
    
    func updateSelectedCategory(_ category: TransactionCategory) {
        selectedCategory = category
    }
}
