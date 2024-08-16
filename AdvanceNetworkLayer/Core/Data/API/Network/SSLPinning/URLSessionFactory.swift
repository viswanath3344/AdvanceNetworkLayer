//
//  URLSessionFactory.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 16/08/24.
//

import Foundation

enum SSLPinningType: String {
    case certificate
    case publicKey
    case none
}

protocol URLSessionFactoryProtocol {
   static func create(sslPinningType: SSLPinningType) -> URLSession
}

final class URLSessionFactory: URLSessionFactoryProtocol {
    static func create(sslPinningType: SSLPinningType = .publicKey) -> URLSession {
        switch sslPinningType {
        case .certificate:
            return  URLSessionWithCertificatePinning().urlSession
        case .publicKey:
            return URLSessionWithPublicKeyPinning().urlSession
        case .none:
           return  URLSession.shared
        }
    }
}
