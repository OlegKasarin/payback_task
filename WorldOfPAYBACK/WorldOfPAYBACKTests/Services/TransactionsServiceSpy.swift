//
//  TransactionsServiceSpy.swift
//  WorldOfPAYBACKTests
//
//  Created by Oleg Kasarin on 08/01/2024.
//

import Foundation
@testable import WorldOfPAYBACK

final class TransactionsServiceSpy: TransactionsServiceProtocol {
    var invokedFetch = false
    var invokedFetchCount = 0
    var stubbedFetchError: Error?
    var stubbedFetchResult: [PBTransaction] = []
    
    func fetch() async throws -> [PBTransaction] {
        invokedFetch = true
        invokedFetchCount += 1
        
        if let error = stubbedFetchError {
            throw error
        }
        
        return stubbedFetchResult
    }
}
