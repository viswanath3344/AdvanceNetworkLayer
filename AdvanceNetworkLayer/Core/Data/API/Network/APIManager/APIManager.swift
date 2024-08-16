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
final class APIManager: NSObject, APIManagerProtocol {
    // 2
    private let urlSession: URLSession
    
    // 3
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: RequestProtocol, authToken: String = "") async throws -> Data {
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


protocol URLSessionProtocol {
    func build() -> URLSession
}

class CustomURLSession: NSObject, URLSessionProtocol, URLSessionDelegate {
    func build() -> URLSession {
         URLSession(configuration: .default, delegate: self, delegateQueue: .current)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let trust = challenge.protectionSpace.serverTrust,
                  SecTrustGetCertificateCount(trust) > 0 {
                   if let certificate = SecTrustCopyCertificateChain(trust) as? [SecCertificate] {
                       let data = SecCertificateCopyData(certificate[0]) as Data
                       
                       if certificates().contains(data) {
                           completionHandler(.useCredential, URLCredential(trust: trust))
                           return
                       } else {
                           //TODO: Throw SSL Certificate Mismatch
                       }
                   }
                   
               }
               completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    
    private func certificates() -> [Data] {
        guard let url =  Bundle.main.url(forResource: "dummyjson.com", withExtension: "der") else {
            return []
        }
        
        let data = try! Data(contentsOf: url)
        return [data]
    }
}
