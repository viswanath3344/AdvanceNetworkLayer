//
//  RequestManager.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

final class RequestManager: RequestManagerProtocol {
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    let accessTokenManager: AccessTokenManagerProtocol
    
    // 1
    init(
        apiManager: APIManagerProtocol = APIManager(),
        parser: DataParserProtocol = DataParser(),
        accessTokenManager: AccessTokenManager = AccessTokenManager()
    ) {
        self.apiManager = apiManager
        self.parser = parser
        self.accessTokenManager = accessTokenManager
    }
    
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        //2
        
        var authToken = ""
        
        // Checks whether the request is authorise request or not.
        if request.isAuthorizeRequest {
            // If the token is valid, get it from local storage.
            if accessTokenManager.isTokenValid() {
                authToken = accessTokenManager.getToken()
            }else {
                authToken = try await requestAccessToken()
                accessTokenManager.refresh(with: authToken)
            }
        }
        
        // 3
        let data = try await apiManager.perform(request, authToken: authToken)
        let decoded: T = try await parser.parse(data)
        return decoded
    }
    
    private func requestAccessToken() async throws -> String {
        // 1
        let data = try await apiManager.requestToken()
        // 2
        let token: APIToken = try await parser.parse(data)
        // 3
        return token.bearerAccessToken
    }
}



