//
//  URLSessionWithPublicKeyPinning.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 16/08/24.
//

import Foundation

final class URLSessionWithPublicKeyPinning: NSObject, URLSessionDelegate {
    var urlSession: URLSession!
    
    override init() {
        super.init()
        self.urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust,
           SecTrustGetCertificateCount(trust) > 0 {
            // Server public key
            let serverPublicKey = SecTrustCopyKey(trust)
            
            // Server public key Data
            let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey!, nil )!
            let data:Data = serverPublicKeyData as Data
            
            // Server Hash key
            let serverHashKey = Hasher.sha256(data: data)
            // Local Hash Key
            let publicKeyLocal = Hasher.localPublicKey
            
            if (serverHashKey == publicKeyLocal) {
                print("SSL Pinning with Public key is successfully completed")
                completionHandler(.useCredential, URLCredential(trust:trust))
                return
            }
            else {
                completionHandler(.cancelAuthenticationChallenge,nil)
                print("SSL Pinning with Public key is failed")
            }
        }
    }
}
