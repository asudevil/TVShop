//
//  AmazonData.swift
//  TVShop
//
//  Created by admin on 1/23/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Alamofire
import Foundation
import SWXMLHash

protocol DownloadFinishProtocol {
    func finishDownload()
}

struct AmazonProduct {
    var smallImage : String?
    var productGroup : String?
    var title : String?
    var price : String?
    var asin : String?
    var brand : String?
    
    mutating func clearAll () {
        smallImage = ""
        productGroup = ""
        title = ""
        price = ""
        asin = ""
        brand = ""
    }
}

enum AmazonProductAdvertising: String {
    case StandardRegion = "webservices.amazon.com"
    case AWSAccessKey = "AWSAccessKeyId"
    case TimestampKey = "Timestamp"
    case SignatureKey = "Signature"
    case VersionKey = "Version"
    case AssociateTagKey = "AssociateTag"
    case CurrentVersion = "2011-08-01"
}

class AmazonData {
    
    var amazonProducts = [AmazonProduct]()
    var product = AmazonProduct()
    var delegate : DownloadFinishProtocol?
    
    let accessKey: String
    let secret: String
    let associateTag : String
    let countPages : Int
    
    var region: String = AmazonProductAdvertising.StandardRegion.rawValue
    var formatPath: String = "/onca/xml"
    var useSSL = true
    var kolvo = 0
    
    init(key: String, secret sec: String, associate:String, countPages:Int) {
        self.secret = sec
        self.accessKey = key
        self.associateTag = associate
        self.countPages = countPages
    }
    
    func searchProducts(searhString: String) {
        
        amazonProducts.removeAll()
        kolvo = 0
        
        var item: Int
        
        for item = 1; item <= self.countPages; ++item {
            
            let amazonParams = [
                "Service" : "AWSECommerceService",
                "Operation" : "ItemSearch",
                "SearchIndex" : "All",
                "ResponseGroup" : "Medium",
                "ItemPage" : String(item),
                "Keywords" : searhString
            ]
            
            amazonRequest(amazonParams)
                .response { (req, res, data, error) -> Void in
                    self.parseData(SWXMLHash.parse(data!))
            }
            
        }
        
        
    }
    
    func parseData(xml: XMLIndexer) {
        
        kolvo++
        
        for elem in xml["ItemSearchResponse"]["Items"]["Item"] {
            
            product.clearAll()
            
            for child in elem.children {
                
                if child.element!.name == "ASIN" {
                    product.asin = child.element?.text
                }
                
                if child.element!.name == "LargeImage" {
                    product.smallImage = child["URL"].element?.text
                }
                
                if child.element!.name == "ItemAttributes" {
                    product.productGroup = child["ProductGroup"].element?.text
                    product.title = child["Title"].element?.text
                    product.brand = child["Brand"].element?.text
                }
                
                if child.element!.name == "OfferSummary" {
                    product.price = child["LowestNewPrice"]["FormattedPrice"].element?.text
                    amazonProducts.append(product)
                }
                
            }
        }
        
        if kolvo == countPages {
            delegate?.finishDownload()
        }
        
        
    }
    
    func amazonRequest(parameters: [String: AnyObject]? = nil) -> Alamofire.Request {
        
        let URL = self.endpointURL()
        
        let e = Alamofire.ParameterEncoding.Custom(self.serializerBlock())
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        
        mutableURLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        
        let encoded: URLRequestConvertible  = e.encode(mutableURLRequest, parameters: parameters).0
        
        return Alamofire.request(encoded)
    }
    
    func endpointURL() -> NSURL {
        let scheme = useSSL ? "https" : "http"
        let URL = NSURL(string: "\(scheme)://\(region)\(formatPath)")
        return URL!
    }
    
    func serializerBlock() -> (URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?) {
        return { (req, params) -> (NSMutableURLRequest, NSError?) in
            
            var mutableParameters = params!
            
            let timestamp = self.ISO8601FormatStringFromDate(NSDate())
            
            if mutableParameters[AmazonProductAdvertising.AWSAccessKey.rawValue] == nil {
                mutableParameters[AmazonProductAdvertising.AWSAccessKey.rawValue] = self.accessKey
            }
            
            if mutableParameters[AmazonProductAdvertising.AssociateTagKey.rawValue] == nil {
                mutableParameters[AmazonProductAdvertising.AssociateTagKey.rawValue] = self.associateTag
            }
            
            
            mutableParameters[AmazonProductAdvertising.VersionKey.rawValue] = AmazonProductAdvertising.CurrentVersion.rawValue;
            mutableParameters[AmazonProductAdvertising.TimestampKey.rawValue] = timestamp;
            
            var canonicalStringArray = [String]()
            
            let sortedKeys = Array(mutableParameters.keys).sort {$0 < $1}
            
            for key in sortedKeys {
                canonicalStringArray.append("\(key)=\(mutableParameters[key]!)")
            }
            
            let canonicalString = canonicalStringArray.joinWithSeparator("&")
            
            let encodedCanonicalString = canonicalString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            
            let method = req.URLRequest.HTTPMethod
            
            let signature = "\(method)\n\(self.region)\n\(self.formatPath)\n\(encodedCanonicalString!)"
            
            let encodedData = signature.hmac(.SHA256, key: self.secret)
            
            var encodedSignatureString = encodedData.base64EncodedStringWithOptions([])
            
            let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}+").invertedSet
            
            encodedSignatureString = encodedSignatureString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
            
            let newCanonicalString = "\(encodedCanonicalString!)&\(AmazonProductAdvertising.SignatureKey.rawValue)=\(encodedSignatureString)"
            
            let absString = req.URLRequest.URL!.absoluteString
            
            let urlString = req.URLRequest.URL?.query != nil ? "\(absString)&\(newCanonicalString)" : "\(absString)?\(newCanonicalString)"
            
            //  print(urlString)
            
            let request = req.URLRequest.mutableCopy() as! NSMutableURLRequest
            request.URL = NSURL(string: urlString)
            
            return (request, nil)
        }
    }
    
    private func ISO8601FormatStringFromDate(date: NSDate) -> NSString {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter.stringFromDate(date)
        
    }
}