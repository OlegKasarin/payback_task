//
//  TransactionsListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

final class TransactionsListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private let transactionsService: TransactionsServiceProtocol
    
    init(transactionsService: TransactionsServiceProtocol) {
        self.transactionsService = transactionsService
    }
    
    @MainActor
    func fetch() async throws {
        do {
            transactions = try await transactionsService.fetchMocked()
        } catch {
            transactions = []
        }
    }
}
