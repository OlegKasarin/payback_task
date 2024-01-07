//
//  TransactionDetailResponse.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct TransactionDetailResponse: Codable {
    let description: String?
    let bookingDate: String?
    let value: TransactionDetailValueResponse?
}
