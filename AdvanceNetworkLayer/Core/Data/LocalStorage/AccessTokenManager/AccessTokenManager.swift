//
//  AccessTokenManager.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

final class AccessTokenManager: AccessTokenManagerProtocol {
    private let key = "Access-Token"
    
    func refresh(with apiToken: String) {
        UserDefaults.standard.setValue(apiToken, forKey: key)
    }
    
    func getToken() -> String {
        UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    func isTokenValid() -> Bool {
        guard let oldToken = UserDefaults.standard.string(forKey: key) else { return false }
        
        // Verify OldToken is expiry or not.
        return !oldToken.isEmpty
    }
}
