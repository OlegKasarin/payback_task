//
//  NetworkAssembly.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import Foundation

struct NetworkAssembly {
    static var requestExecutor: RequestExecutorProtocol {
        RequestExecutor(builder: URLRequestBuilder())
    }
}
