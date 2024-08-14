//
//  DataParser.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 14/08/24.
//

import Foundation

protocol DataParserProtocol {
     func parse<T: Decodable>(_ data: Data) async throws -> T
}

struct DataParser: DataParserProtocol {
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func parse<T>(_ data: Data) async throws -> T where T : Decodable {
        return try decoder.decode(T.self, from: data)
    }
}
