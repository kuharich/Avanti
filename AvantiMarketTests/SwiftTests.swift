//
//  SwiftTests.swift
//  AvantiMarket
//
//  Created by Tero Jankko on 7/13/16.
//  Copyright © 2016 BYNDL. All rights reserved.
//

import XCTest


class SwiftTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSavePassword() {
        let _ = KeychainHelper.setStringWithKey("testPassword", forKey:"passwordKey")
        XCTAssertEqual(KeychainHelper.getStringWithKey("passwordKey"), "testPassword", "Didn't get correct password")
    }

    func testUpdatePassword() {
        let passwordKey = "passwordKey"
        let testPassword = "testPassword"
        let newTestPassword = "newTestPassword"
        let _ = KeychainHelper.setStringWithKey(testPassword, forKey:passwordKey)
        let _ = KeychainHelper.setStringWithKey(newTestPassword, forKey:passwordKey)
        XCTAssertEqual(KeychainHelper.getStringWithKey(passwordKey), newTestPassword, "Didn't get correct password")
    }
    
    func testNonExistentKey() {
        XCTAssertNil(KeychainHelper.getStringWithKey("\(Date().timeIntervalSince1970)"), "Expected nil")
    }
    
    let key = "AuthenticateRequest"
    
    func testRemoveWithKey() {
        let mykey = "mykey"
        let _ = KeychainHelper.setStringWithKey("myValue", forKey:mykey)
        XCTAssertNotNil(KeychainHelper.getStringWithKey(mykey))
        let _ = KeychainHelper.removeWithKey(mykey)
        XCTAssertNil(KeychainHelper.getStringWithKey(mykey))
    }
    
    func testMoveCredentialsWhenOnlyUserDefaultsExists() {
        setCredentialsInUserDefaults()
        KeychainHelper.moveUsernameAndPassword()
        XCTAssertNil(UserDefaults.standard.object(forKey: key))
        XCTAssertEqual(KeychainHelper.getStringWithKey("username"), "name")
        XCTAssertEqual(KeychainHelper.getStringWithKey("password"), "pwd")
    }
    
    func testMoveCredentialsWhenUserDefaultsDoesntExist() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
        KeychainHelper.moveUsernameAndPassword()
        XCTAssertNil(UserDefaults.standard.object(forKey: key))
        // shouldn't crash at least
        // nothing should happen
    }
    
    func testMoveCredentialsWhenBothExist() {
        setCredentialsInUserDefaults()
        let _ = KeychainHelper.setStringWithKey("name", forKey:"username")
        let _ = KeychainHelper.setStringWithKey("pwd", forKey:"password")
        let _ = KeychainHelper.moveUsernameAndPassword()
        // expecting to be removed from UserDefaults but not overwritten existing Keychain
        XCTAssertNil(UserDefaults.standard.object(forKey: key))
        XCTAssertEqual(KeychainHelper.getStringWithKey("username"), "name")
        XCTAssertEqual(KeychainHelper.getStringWithKey("password"), "pwd")
    }
    
    func testMoveCredentialsWhenOnlyKeychainExists() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
        let _ = KeychainHelper.setStringWithKey("name", forKey:"username")
        let _ = KeychainHelper.setStringWithKey("pwd", forKey:"password")
        let _ = KeychainHelper.moveUsernameAndPassword()
        // nothing should change
        XCTAssertNil(UserDefaults.standard.object(forKey: key))
        XCTAssertEqual(KeychainHelper.getStringWithKey("username"), "name")
        XCTAssertEqual(KeychainHelper.getStringWithKey("password"), "pwd")
    }
    
    func setCredentialsInUserDefaults() {
        let authRequest = AuthenticateRequest()
        authRequest.userName = "name"
        authRequest.userPassword = "pwd"
        let defaults = UserDefaults.standard
        defaults.set(authRequest.data(), forKey: key)
        XCTAssertNotNil(UserDefaults.standard.object(forKey: key))
    }

}
