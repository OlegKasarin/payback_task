//
//  TransactionCategory.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 07/01/2024.
//

import Foundation

enum TransactionCategory: String, CaseIterable {
    case all
    case first
    case second
    case third
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .first:
            return "1"
        case .second:
            return "2"
        case .third:
            return "3"
        }
    }
    
    var categoryNumber: Int {
        switch self {
        case .all:
            return -1
        case .first:
            return 1
        case .second:
            return 2
        case .third:
            return 3
        }
    }
}
