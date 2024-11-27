//
//  TodoNetworkError.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 13/11/24.
//

import Foundation

enum TodoError: Error {
    case noInternet
    case networkLost
    case requestTimeout
    case unknownError
}
