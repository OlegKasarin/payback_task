//
//  RequestExecutor.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import Foundation

typealias URLResponsePayload = (response: URLResponse?, data: Data?)

protocol RequestExecutorProtocol {
    func execute<T: Decodable>(request: HTTPRequest) async throws -> T
}

final class RequestExecutor {
    private let builder: URLRequestBuilderProtocol
    
    init(builder: URLRequestBuilderProtocol) {
        self.builder = builder
    }
}

// MARK: - RequestExecutorProtocol

extension RequestExecutor: RequestExecutorProtocol {
    func execute<T: Decodable>(request: HTTPRequest) async throws -> T {
        let urlRequest = try builder.buildThrows(request: request)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "Error"
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension String: Error { }
