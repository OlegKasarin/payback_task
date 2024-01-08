//
//  Transaction.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct Transaction: Hashable {
    let id: Int
    let partnerDisplayName: String
    let category: Int
    
    private let description: String?
    let bookingDate: Date
    let amount: Int
    private let currency: String
    
    // MARK: - Computed properties
    
    var amountLabel: String {
        String(amount) + " " + currency
    }
    
    var descriptionLabel: String {
        description ?? ""
    }
    
    var dateLabel: String {
        BusinessUtils.displaySmartDateString(date: bookingDate)
    }
}

extension Transaction {
    init?(response: TransactionResponse) {
        let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            return formatter
        }()
        
        guard
            let reference = response.alias?.reference,
            let id = Int(reference),
            let dateResponse = response.transactionDetail?.bookingDate,
            let date = dateFormatter.date(from: dateResponse)
        else {
            debugPrint("Error: parsing TransactionResponse")
            return nil
        }
        
        self.init(
            id: id,
            partnerDisplayName: response.partnerDisplayName ?? "",
            category: response.category ?? .zero,
            description: response.transactionDetail?.description,
            bookingDate: date,
            amount: response.transactionDetail?.value?.amount ?? .zero,
            currency: response.transactionDetail?.value?.currency ?? BusinessUtils.currencySign
        )
    }
    
    static var mocked: Transaction {
        Transaction(
            id: 1234,
            partnerDisplayName: "PARTNER NAME",
            category: 1,
            description: "DESCRIPTION",
            bookingDate: .now,
            amount: 999,
            currency: "QWE"
        )
    }
}
