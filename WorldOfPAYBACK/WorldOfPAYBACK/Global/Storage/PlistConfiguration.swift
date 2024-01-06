//
//  PlistConfiguration.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import Foundation

protocol BERequestParameters {
    var serverUrl: String { get }
}

final class PlistFile<Model: Decodable> {
    let model: Model
    
    enum PlistError: Error {
        case fileNotFound
    }
    
    enum Source {
        case infoPlist(_: Bundle)
        
        func data() throws -> Data {
            switch self {
            case .infoPlist(let bundle):
                guard let info = bundle.infoDictionary else {
                    throw PlistError.fileNotFound
                }
                
                return try JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
            }
        }
    }
    
    init(source: PlistFile.Source = .infoPlist(Bundle.main)) throws {
        do {
            let data = try source.data()
            model = try JSONDecoder().decode(Model.self, from: data)
        } catch let error {
            debugPrint("PlistFile cannot read data - \(error)")
            throw error
        }
    }
}

struct InfoPlist: Decodable {
    let customParameters: CustomParameters
    
    enum CodingKeys: String, CodingKey {
        case customParameters = "CustomParameters"
    }
    
    struct CustomParameters: Decodable, BERequestParameters {
        let baseUrl: String
        let transferProtocol: String
        
        var serverUrl: String {
            transferProtocol + "://" + baseUrl
        }
    }
}
