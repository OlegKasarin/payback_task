//
//  TransactionsListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct TransactionsSection {
    let title: String
    let transactions: [PBTransaction]
}

final class TransactionsListViewModel: ObservableObject {
    @Published var transactions: [PBTransaction] = []
    @Published var selectedCategory: TransactionCategory = .all
    
    @Published var isLoading = false
    @Published var isError = false
    
    private let transactionsService: TransactionsServiceProtocol
    
    var transactionsSections: [TransactionsSection] {
        var dataSource: [String: [PBTransaction]] = [:]
        for transaction in transactionsToDisplay {
            if var transactions = dataSource[transaction.dateLabel] {
                transactions.append(transaction)
                dataSource[transaction.dateLabel] = transactions
            } else {
                dataSource[transaction.dateLabel] = [transaction]
            }
        }
        
        return dataSource.map { 
            TransactionsSection(title: $0.key, transactions: $0.value)
        }
    }
    
    var transactionsToDisplay: [PBTransaction] {
        switch selectedCategory {
        case .all:
            return transactions
        case .first, .second, .third:
            return transactions.filter { $0.category == selectedCategory.categoryNumber }
        }
    }
    
    var sumToDisplay: String {
        // In case if we have more than 1 currency
        let grouped = Dictionary(grouping: transactionsToDisplay, by: { $0.currency })
        let result: String = grouped.map {
            let sum = $0.value.reduce(0) { partialResult, transaction in
                partialResult + transaction.amount
            }
            return String("\(sum) \($0.key)")
        }.joined(separator: " | ")
        
        return result
        
        // Assumption that we have one common corrency
//        let sum = transactionsToDisplay.reduce(0) { partialResult, transaction in
//            partialResult + transaction.amount
//        }
//        return String("Sum: \(sum)")
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
        }
    }
    
    func updateSelectedCategory(_ category: TransactionCategory) {
        selectedCategory = category
    }
}
