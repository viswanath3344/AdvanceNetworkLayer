//
//  Protocols.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

enum RequestType: String {
    case GET
    case POST
}

protocol RequestProtocol {
    var path: String { get }
    
    var headers: [String: String] { get }
    var params : [String: Any] { get }
    
    var urlParams: [String: String?] { get }
    
    var isAuthorizeRequest: Bool { get }
    
    var requestType: RequestType { get }
}


extension RequestProtocol {
    var host: String {
        APIConstants.host
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var params: [String: Any] {
        [:]
    }
    
    var urlParams: [String: String?] {
        [:]
    }
    
    var isAuthorizeRequest: Bool {
        true
    }
    
    // 1
    func createURLRequest(authToken: String = "") throws -> URLRequest {
      // 2
      var components = URLComponents()
      components.scheme = "https"
      components.host = host
      components.path = path
      // 3
      if !urlParams.isEmpty {
        components.queryItems = urlParams.map {
          URLQueryItem(name: $0, value: $1)
        }
      }

      guard let url = components.url
      else { throw NetworkError.invalidURL }

      // 4
      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = requestType.rawValue
      // 5
      if !headers.isEmpty {
        urlRequest.allHTTPHeaderFields = headers
      }
      // 6
        if isAuthorizeRequest {
        urlRequest.setValue(authToken,
          forHTTPHeaderField: "Authorization")
      }
      // 7
      urlRequest.setValue("application/json",
        forHTTPHeaderField: "Content-Type")
      // 8
      if !params.isEmpty {
        urlRequest.httpBody = try JSONSerialization.data(
          withJSONObject: params)
      }

      return urlRequest
    }
}
