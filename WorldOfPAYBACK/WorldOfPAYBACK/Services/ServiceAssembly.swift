//
//  ServiceAssembly.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

final class ServiceAssembly {
    private static let shared = ServiceAssembly()
    
    static var transactionsService: TransactionsServiceProtocol {
        TransactionsService(executor: NetworkAssembly.requestExecutor)
    }
}
