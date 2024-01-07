//
//  TransactionResponse.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct TransactionResponse: Codable {
    let partnerDisplayName: String?
    let alias: TransactionAliasResponse?
    let category: Int?
    let transactionDetail: TransactionDetailResponse?
}
