//
//  Transaction.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct Transaction {
    let id: Int
    let partnerDisplayName: String
    let category: Int
    
    private let description: String?
    let bookingDate: Date
    private let amount: Int
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
    
    private let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    init?(response: TransactionResponse) {
        guard 
            let reference = response.alias?.reference,
            let id = Int(reference),
            let dateResponse = response.transactionDetail?.bookingDate,
            let date = dateFormatter.date(from: dateResponse)
        else {
            debugPrint("Error: parsing TransactionResponse")
            return nil
        }
        
        self.id = id
        partnerDisplayName = response.partnerDisplayName ?? ""
        category = response.category ?? .zero
        description = response.transactionDetail?.description
        bookingDate = date
        amount = response.transactionDetail?.value?.amount ?? .zero
        currency = response.transactionDetail?.value?.currency ?? "PBP"
    }
}
