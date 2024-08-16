//
//  Hasher.swift
//  AdvanceNetworkLayer
//
//  Created by Ponthota, Viswanath Reddy on 16/08/24.
//

import Foundation
import CommonCrypto


//MARK: With Public Key Pinning.
// Ref: https://mahmudul-razib.medium.com/ssl-pinning-in-ios-a985895c4414
// Ref: https://www.ssllabs.com/ssltest
// Ref: https://github.com/zhouhao27/SSLPinningTest/blob/main/SSLPinningTest/ViewModel.swift

final class Hasher {
    public static let localPublicKey = "Vpa6XSraME9QRLbp/GNPUxMXhU+iU93kUKqJ/h8CSBU="
    
    private static let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ];
    
    static func sha256(data : Data) -> String {
        var keyWithHeader = Data(Hasher.rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(Hasher.rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), &hash)
        }
        
        return Data(hash).base64EncodedString()
    }
}
