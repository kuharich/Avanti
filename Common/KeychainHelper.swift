//
//  KeychainHelper.swift
//  AvantiMarket
//
//  Created by Mark Kuharich on 7/13/16.
//  Copyright © 2016 BYNDL. All rights reserved.
//

import Foundation
import Security

struct KeychainSwiftConstants{
    internal static var accessible: String { return toString(kSecAttrAccessible) }
    
    /// Used for specifying a String key when setting/getting a Keychain value.
    internal static var attrAccount: String { return toString(kSecAttrAccount) }
    
    /// Used for specifying synchronization of keychain items between devices.
    internal static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
    
    /// An item class key used to construct a Keychain search dictionary.
    internal static var klass: String { return toString(kSecClass) }
    
    /// Specifies the number of values returned from the keychain. The library only supports single values.
    internal static var matchLimit: String { return toString(kSecMatchLimit) }
    
    /// A return data type used to get the data from the Keychain.
    internal static var returnData: String { return toString(kSecReturnData) }
    
    /// Used for specifying a value when setting a Keychain value.
    internal static var valueData: String { return toString(kSecValueData) }
    
    static func toString(_ value: CFString) -> String {
        return value as String
    }
}

open class KeychainHelper: NSObject  {
    
    class func getStringWithKey(_ key: String) -> String? {
        
        let query: [String: NSObject] = [
            KeychainSwiftConstants.klass       : kSecClassGenericPassword,
            KeychainSwiftConstants.attrAccount : key as NSObject,
            KeychainSwiftConstants.returnData  : kCFBooleanTrue,
            KeychainSwiftConstants.matchLimit  : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr { return String(data: (result as? Data)!, encoding: String.Encoding.utf8) as String? }
        
        return nil
    }
    
    class func setStringWithKey(_ value: String, forKey key: String) -> Bool {
        
        var query: [String: NSObject] = [
            KeychainSwiftConstants.klass       : kSecClassGenericPassword,
            KeychainSwiftConstants.attrAccount : key as NSObject
        ]
        
        // just delete in case the item exists
        var result = SecItemDelete(query as CFDictionary)
        
        query = [
            KeychainSwiftConstants.klass       : kSecClassGenericPassword,
            KeychainSwiftConstants.attrAccount : key as NSObject,
            KeychainSwiftConstants.valueData   : value.data(using: String.Encoding.utf8)! as NSObject,
            KeychainSwiftConstants.accessible  : kSecAttrAccessibleWhenUnlocked
        ]
        
        result = SecItemAdd(query as CFDictionary, nil)
        
        return result == noErr
    }
    
    class func moveUsernameAndPassword() {
        let key = "AuthenticateRequest"
        let defaults = UserDefaults.standard
        let userNameKey = "username"
        let passwordKey = "password"
        if let data = defaults.object(forKey: key) {
            if getStringWithKey(userNameKey) == nil { // don't overwrite existing values
                let authRequest = AuthenticateRequest.authenticateResuest(with: data as! Data)
                let _ = self.setStringWithKey((authRequest?.userName)!, forKey: userNameKey)
                let _ = self.setStringWithKey((authRequest?.userPassword)!, forKey: passwordKey)
            }
            defaults.removeObject(forKey: key)
                
        }
    }
    
    class func removeWithKey(_ key: String) -> Bool {
        let query: [String: NSObject] = [
            KeychainSwiftConstants.klass       : kSecClassGenericPassword,
            KeychainSwiftConstants.attrAccount : key as NSObject
        ]

        let result = SecItemDelete(query as CFDictionary)
        return result == noErr
    }

}


