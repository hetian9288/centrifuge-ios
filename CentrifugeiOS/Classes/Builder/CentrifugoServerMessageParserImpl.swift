//
//  CentrifugeServerMessageParserImpl.swift
//  Pods
//
//  Created by Herman Saprykin on 19/04/16.
//
//

protocol CentrifugeServerMessageParser {
    func parse(data: Data) throws -> [CentrifugeServerMessage]
}

class CentrifugeServerMessageParserImpl: CentrifugeServerMessageParser {
    
    func parse(data: Data) throws -> [CentrifugeServerMessage] {
        var messages = [CentrifugeServerMessage]()
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            
            if let infos = response as? [[String : AnyObject]] {
                for info in infos {
                    if let message = messageParse(info: info){
                        messages.append(message)
                    }
                }
            }
            if let info = response as? [String : AnyObject] {
                if let message = messageParse(info: info){
                    messages.append(message)
                }
            }
        } catch {
            print("Error: Json消息解析失败")
        }
        return messages
    }
    
    func messageParse(info: [String : AnyObject]) -> CentrifugeServerMessage? {
        guard let uid = info["uid"] as? String? else {
            return nil
        }
        
        guard let methodName = info["method"] as? String else {
            return nil
        }
        
        guard let method = CentrifugeMethod(rawValue: methodName) else {
            return nil
        }
        var error: String?
        
        if let err = info["error"] as? String {
            error = err
        }
        
        var body: [String: AnyObject]?
        
        if let bd = info["body"] as? [String : AnyObject] {
            body = bd
        }
        
        return CentrifugeServerMessage(uid: uid, method: method, error: error, body: body)
    }
}
