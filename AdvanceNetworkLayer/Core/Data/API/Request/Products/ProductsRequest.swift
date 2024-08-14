//
//  ProductsRequest.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

// 1
enum ProductsRequest: RequestProtocol {
    case getProducts
    // 2
    var path: String {
        "/products"
    }
    // 3
    var urlParams: [String: String?] {
        [:]
    }
    // 4
    var requestType: RequestType {
        .GET
    }
    
    var isAuthorizeRequest: Bool {
        false
    }
}

