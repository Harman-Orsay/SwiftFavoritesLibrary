//
//  Keychain.swift
//  
//
//  Created by Rohan Ramsay on 30/12/20.
//

import Foundation

public class Keychain {
    
    static let service = "App.Keychain"
    
    public enum Error: LocalizedError {
        
        case notFound
        case typeCast
        case unknown
    }
    
    public enum Item {
        
        case token
        case key(label: String)
        case password(account: String)
    }
}

//MARK:- API

public extension Keychain {
    
    static func find(item: Item) throws -> Data {
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(item.findAttributes(), UnsafeMutablePointer($0))
        }
        
        if status == errSecItemNotFound {
            throw Error.notFound
        }
        
        guard status == noErr else {
            throw Error.unknown
        }
        
        guard let itemData = queryResult as? Data else {
            throw Error.typeCast
        }
        
        return itemData
    }
    
    static func save(item: Item, with data: Data) throws { //& update??
        let status = SecItemAdd(item.addAttributes(data: data), nil)
        
        guard status == noErr else {
            throw Error.unknown
        }
    }
    
    static func update(item: Item, with data: Data) throws { //or add??
        let status = SecItemUpdate(item.identityAttributes(),
                                   item.updateAttributes(data: data))
        guard status == noErr else {
            throw Error.unknown
        }
    }
    
    static func delete(item: Item) throws {
        let status = SecItemDelete(item.identityAttributes())
        
        guard status == noErr || status == errSecItemNotFound else {
            throw Error.unknown
        }
    }
}

//MARK:- Utility

extension Keychain.Item {
    
    fileprivate var attributes: [String: AnyObject] {
        var attributes = [String: AnyObject]()
        attributes[kSecAttrService as String] = Keychain.service as AnyObject
        
        switch self {
        case .token:
            attributes[kSecClass as String] = kSecClassKey as AnyObject
            
        case .key(let label):
            attributes[kSecClass as String] = kSecClassKey as AnyObject
            attributes[kSecAttrLabel as String] = label as AnyObject
            
        case .password(account: let account):
            attributes[kSecClass as String] = kSecClassGenericPassword as AnyObject
            attributes[kSecAttrAccount as String] = account as AnyObject
        }
        
        return attributes
    }
    
    fileprivate func identityAttributes() -> CFDictionary {
        attributes as CFDictionary
    }
    
    fileprivate func addAttributes(data: Data) -> CFDictionary {
        var addAttributes = attributes
        addAttributes[kSecValueData as String] = data as AnyObject
        return addAttributes as CFDictionary
    }
    
    fileprivate func updateAttributes(data: Data) -> CFDictionary {
        [kSecValueData: data as AnyObject] as CFDictionary
    }
    
    fileprivate func findAttributes() -> CFDictionary {
        var findAttributes = attributes
        findAttributes[kSecMatchLimit as String] = kSecMatchLimitOne as AnyObject
        findAttributes[kSecReturnData as String] = true as AnyObject
        return findAttributes as CFDictionary
    }
}
