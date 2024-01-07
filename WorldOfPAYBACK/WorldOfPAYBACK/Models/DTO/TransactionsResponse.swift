//
//  TransactionsResponse.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct TransactionsResponse: Codable {
    let items: [TransactionResponse]
}

extension TransactionsResponse {
    static func mockedResponse() -> [TransactionResponse] {
        do {
            guard
                let bundlePath = Bundle.main.path(forResource: "PBTransactions", ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
            else {
                return []
            }
            
            let response = try JSONDecoder().decode(TransactionsResponse.self, from: jsonData)
            return response.items
        } catch {
            print(error)
            return []
        }
    }
}
