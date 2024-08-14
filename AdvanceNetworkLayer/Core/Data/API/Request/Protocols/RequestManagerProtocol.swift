//
//  RequestManagerProtocol.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}
