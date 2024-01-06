//
//  TransactionsService.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

protocol TransactionsServiceProtocol {
    func fetch() async throws -> [Transaction]
    func fetchMocked() async throws -> [Transaction]
}

final class TransactionsService {
    private let executor: RequestExecutorProtocol
    
    init(executor: RequestExecutorProtocol) {
        self.executor = executor
    }
}

// MARK: - TransactionsServiceProtocol

extension TransactionsService: TransactionsServiceProtocol {
    func fetch() async throws -> [Transaction] {
        let request = FetchTransactionsRequest()
        
        let response: [TransactionResponse] = try await executor.execute(request: request)
        let transactions = response.compactMap {
            Transaction(response: $0)
        }
        
        return transactions
    }
    
    func fetchMocked() async throws -> [Transaction] {
        await Task(priority: .medium) {
          // Block the thread as a real heavy-computation function will.
          await withUnsafeContinuation { continuation in
            Thread.sleep(forTimeInterval: 1)
            continuation.resume()
          }
        }.value

        let mocked = TransactionResponse.mockedTransactions()
        
        let transactions = mocked.compactMap {
            Transaction(response: $0)
        }
        
        return transactions
    }
}
