//
//  TransactionsService.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

protocol TransactionsServiceProtocol {
    func fetch() async throws -> [PBTransaction]
    func fetchMocked() async throws -> [PBTransaction]
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
    
    func fetchMocked() async throws -> [PBTransaction] {
        await Task(priority: .medium) {
          // Block the thread as a real heavy-computation function will.
          await withUnsafeContinuation { continuation in
            Thread.sleep(forTimeInterval: 1)
            continuation.resume()
          }
        }.value

        let mocked = TransactionResponse.mockedTransactions()
        
        let transactions = mocked.compactMap {
            PBTransaction(response: $0)
        }
        
        return transactions
    }
}
