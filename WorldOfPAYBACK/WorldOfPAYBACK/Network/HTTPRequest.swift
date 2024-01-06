//
//  HTTPRequest.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import Foundation

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

typealias HTTPBody = [String: Any]

protocol HTTPRequest {
    var method: HTTPRequestMethod { get }
    var baseURL: String { get }
    var path: HTTPPath { get }
    var bodyPayload: HTTPBody? { get }
}
