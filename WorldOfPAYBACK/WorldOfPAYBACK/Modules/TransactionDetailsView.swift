//
//  TransactionDetailsView.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 08/01/2024.
//

import SwiftUI

struct TransactionDetailsView: View {
    let transaction: Transaction
    
    var body: some View {
        Text(transaction.partnerDisplayName)
            .font(.title)
            .padding()
        Text(transaction.descriptionLabel)
    }
}

#Preview {
    TransactionDetailsView(transaction: Transaction.mocked)
}
