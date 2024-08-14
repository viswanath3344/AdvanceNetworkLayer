//
//  ProductsDTO.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 14/08/24.
//

import Foundation

struct ProductsContainer: Decodable {
    let products: [Product]
}

struct Product: Decodable {
    let id: Int
    let title: String
}
