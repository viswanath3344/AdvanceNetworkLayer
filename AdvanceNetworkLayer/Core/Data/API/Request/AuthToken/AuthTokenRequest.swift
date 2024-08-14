//
//  AuthTokenRequest.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

// 1
enum AuthTokenRequest: RequestProtocol {
  case auth
  // 2
  var path: String {
    "/v2/oauth2/token"
  }
  // 3
  var params: [String: Any] {
    [
      "grant_type": APIConstants.grantType,
      "client_id": APIConstants.clientId,
      "client_secret": APIConstants.clientSecret
    ]
  }
  // 4
  var isAuthorizeRequest: Bool {
    false
  }
  // 5
  var requestType: RequestType {
    .POST
  }
}
