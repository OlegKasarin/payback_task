//
//  FetchTransactionsRequest.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 06/01/2024.
//

import Foundation

struct FetchTransactionsRequest: HTTPRequest {
    var method: HTTPRequestMethod {
        .get
    }
    
    var baseURL: String {
        ""
    }
    
    var path: HTTPPath {
        .transactions
    }
    
    var bodyPayload: HTTPBody? {
        nil
    }
}
