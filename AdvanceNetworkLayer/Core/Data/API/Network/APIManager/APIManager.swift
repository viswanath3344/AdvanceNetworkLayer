//
//  APIManagerProtocol.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol, authToken: String) async throws -> Data
    func requestToken() async throws -> Data
}

// 1
class APIManager: APIManagerProtocol {
  // 2
  private let urlSession: URLSession

  // 3
  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
    
    func perform(
        _ request: RequestProtocol,
        authToken: String = ""
    ) async throws -> Data {
      // 1
        let urlRequest = try request.createURLRequest(authToken: authToken)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
      // 2
      guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode == 200
      else {
        // 3
        throw NetworkError.invalidServerResponse
      }
      return data
    }

    func requestToken() async throws -> Data {
      try await perform(AuthTokenRequest.auth)
    }

}

