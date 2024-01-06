//
//  AppStorage.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 04/01/2024.
//

import Foundation

protocol AppStorageInterface {
    var backendRequestParameters: BERequestParameters { get }
}
    
final class AppStorage {
    static let shared = AppStorage()
    
    private lazy var infoPlist: InfoPlist = {
        do {
            return try PlistFile<InfoPlist>().model
        } catch {
            fatalError("AppStorage cannot read info plist. Check config files")
        }
    }()
}

// MARK: - AppStorageInterface

extension AppStorage: AppStorageInterface {
    var backendRequestParameters: BERequestParameters {
        infoPlist.customParameters
    }
}
