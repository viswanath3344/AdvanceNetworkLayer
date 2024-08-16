//
//  URLSessionWithCertificatePinning.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 16/08/24.
//

import Foundation

final class URLSessionWithCertificatePinning: NSObject, URLSessionDelegate {
    var urlSession: URLSession!
    
    override init() {
        super.init()
        self.urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let trust = challenge.protectionSpace.serverTrust,
           SecTrustGetCertificateCount(trust) > 0 {
            if let certificate = SecTrustCopyCertificateChain(trust) as? [SecCertificate] {
                let data = SecCertificateCopyData(certificate[0]) as Data
                
                if getLocalCertificateData().contains(data) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    return
                } else {
                    //TODO: Throw SSL Certificate Mismatch
                }
            }
            
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    private func getLocalCertificateData() -> [Data] {
        guard let url =  Bundle.main.url(forResource: "dummyjson.com", withExtension: "der") else {
            return []
        }
        
        let data = try! Data(contentsOf: url)
        return [data]
    }
}

