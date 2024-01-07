//
//  WorldOfPAYBACKApp.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import SwiftUI

@main
struct WorldOfPAYBACKApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TransactionsListViewModel(
                transactionsService: ServiceAssembly.transactionsService
            ))
        }
    }
}
