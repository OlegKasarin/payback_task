//
//  TransactionsListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct TransactionsSection {
    let date: Date
    let transactions: [PBTransaction]
    
    var titleLabel: String {
        BusinessUtils.displaySmartDateString(date: date)
    }
}

final class TransactionsListViewModel: ObservableObject {
    @Published var transactions: [PBTransaction] = []
    @Published var selectedCategory: TransactionCategory = .all
    
    @Published var isLoading = false
    @Published var isError = false
    
    private let transactionsService: TransactionsServiceProtocol
    
    init(transactionsService: TransactionsServiceProtocol) {
        self.transactionsService = transactionsService
    }
    
    var transactionsSections: [TransactionsSection] {
        var dataSource: [Date: [PBTransaction]] = [:]
        for transaction in transactionsToDisplay {
            if var transactions = dataSource[transaction.bookingDate] {
                transactions.append(transaction)
                dataSource[transaction.bookingDate] = transactions
            } else {
                dataSource[transaction.bookingDate] = [transaction]
            }
        }
        
        return dataSource
            .map { TransactionsSection(date: $0.key, transactions: $0.value) }
            .sorted(by: { $0.date > $1.date })
    }
    
    private var transactionsToDisplay: [PBTransaction] {
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
        
        return String("Sum: \(result)")
        
        // Assumption that we have one common corrency
//        let sum = transactionsToDisplay.reduce(0) { partialResult, transaction in
//            partialResult + transaction.amount
//        }
//        return String("Sum: \(sum)")
    }
    
    @MainActor
    func fetch() async throws {
        isLoading = true
        do {
            let transactions = try await transactionsService.fetch()
            
            isLoading = false
            self.transactions = transactions
        } catch {
            isLoading = false
            isError = true
        }
    }
    
    func updateSelectedCategory(_ category: TransactionCategory) {
        selectedCategory = category
    }
}
