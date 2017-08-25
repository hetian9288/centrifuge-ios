//
//  Centrifugal.swift
//  Pods
//
//  Created by Herman Saprykin on 18/04/16.
//
//

import IDZSwiftCommonCrypto

public let CentrifugeAuthErrorDomain = "com.Centrifuge.error.domain.auth"
public let CentrifugeErrorDomain = "com.Centrifuge.error.domain"
public let CentrifugeWebSocketErrorDomain = "com.Centrifuge.error.domain.websocket"
public let CentrifugeErrorMessageKey = "com.Centrifuge.error.messagekey"

public enum CentrifugeErrorCode: Int {
    case CentrifugeMessageWithError
}

public typealias CentrifugeMessageHandler = (CentrifugeServerMessage?, NSError?) -> Void

public class Centrifuge {
    
    static let privateChannelPrefix = "$"
    
    @available(*, deprecated, message: "Use method with CentrifugeConfig instead")
    public class func client(url: String, secret: String, creds: CentrifugeCredentials, delegate: CentrifugeClientDelegate) -> CentrifugeClient {
        let conf = CentrifugeConfig(url: url, secret: secret)
        
        return client(conf: conf, creds: creds, delegate: delegate)
    }
    
    public class func client(conf: CentrifugeConfig, creds: CentrifugeCredentials, delegate: CentrifugeClientDelegate) -> CentrifugeClient {
        let client = CentrifugeClientImpl()
        client.builder = CentrifugeClientMessageBuilderImpl()
        client.parser = CentrifugeServerMessageParserImpl()
        client.creds = creds
        client.conf = conf
        client.delegate = delegate
        
        return client
    }
    
    public class func createToken(string: String, key: String) -> String {
        let hmacs5 = HMAC(algorithm:.sha256, key:key).update(string: string)?.final()
        let token = hexString(fromArray: hmacs5!)
        return token
    }
}
