//
//  AccessTokenManagerProtocol.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

protocol AccessTokenManagerProtocol {
    func isTokenValid() -> Bool
    func refresh(with apiToken: String)
    func getToken() -> String
}
