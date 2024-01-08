//
//  TransactionsService.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

protocol TransactionsServiceProtocol {
    func fetch() async throws -> [PBTransaction]
}

final class TransactionsService {
    private let executor: RequestExecutorProtocol
    
    init(executor: RequestExecutorProtocol) {
        self.executor = executor
    }
}

// MARK: - TransactionsServiceProtocol

extension TransactionsService: TransactionsServiceProtocol {
    func fetch() async throws -> [PBTransaction] {
        let request = FetchTransactionsRequest()
        
        let response: [TransactionResponse] = try await executor.execute(request: request)
        let transactions = response.compactMap {
            PBTransaction(response: $0)
        }
        
        return transactions
    }
}
