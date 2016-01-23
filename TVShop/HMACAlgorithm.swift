//
//  HMACAlgorithm.swift
//  TVShop
//
//  Created by admin on 1/23/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> NSData {
        
        let data = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        let digestLen = algorithm.digestLength
        let keyStr = key.cStringUsingEncoding(NSASCIIStringEncoding)
        
        let context = UnsafeMutablePointer<CCHmacContext>.alloc(1)
        
        CCHmacInit(context, algorithm.HMACAlgorithm, keyStr!, keyStr!.count);
        CCHmacUpdate(context, data!.bytes, data!.length);
        
        
        var digest = Array<UInt8>(count: digestLen, repeatedValue:0)
        
        CCHmacFinal(context, &digest)
        
        context.dealloc(digestLen)
        
        return NSData(bytes: digest, length: digestLen)
    }
    
}
