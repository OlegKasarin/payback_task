//
//  FakeTransactionsService.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 08/01/2024.
//

import Foundation

final class FakeTransactionsService {
    
}

// MARK: - TransactionsServiceProtocol

extension FakeTransactionsService: TransactionsServiceProtocol {
    func fetch() async throws -> [PBTransaction] {
        await Task(priority: .medium) {
          // Block the thread as a real heavy-computation function will.
          await withUnsafeContinuation { continuation in
            Thread.sleep(forTimeInterval: 1)
            continuation.resume()
          }
        }.value

        let random = Int.random(in: 0...3)
        if random % 2 == 0 {
            throw "Fetching error"
        }
        
        let mocked = TransactionsResponse.mockedResponse()
        
        let transactions = mocked.compactMap {
            PBTransaction(response: $0)
        }
        
        return transactions
    }
}
