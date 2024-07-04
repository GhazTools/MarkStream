//
//  tokenGranterTests.swift
//  MarkStreamTests
//
//  Created by Ghazanfar Shahbaz on 6/30/24.
//

import Foundation
import XCTest


class TokenGranterTests: XCTestCase {
    var tokenGranter: TokenGranter!
    var username: String = ProcessInfo.processInfo.environment["APP_USERNAME"] ?? "";
    var password: String = ProcessInfo.processInfo.environment["APP_PASSWORD"] ?? "";
    
    override func setUp() {
        super.setUp()
        
        // Read local.config
        if(self.username.isEmpty){
            let configPath = Bundle.main.path(forResource: "local", ofType: "config") // Adjust the path as necessary
            if let configPath = configPath, let configContents = try? String(contentsOfFile: configPath) {
                let lines = configContents.split(separator: "\n")
                var configDict = [String: String]()
                lines.forEach { line in
                    let parts = line.split(separator: "=", maxSplits: 1).map { String($0) }
                    if parts.count == 2 {
                        configDict[parts[0]] = parts[1]
                    }
                }
                self.username = configDict["APP_USERNAME"] ?? ""
                self.password = configDict["APP_PASSWORD"] ?? ""
            }
        }

        tokenGranter = TokenGranter(username: self.username, password: self.password)
    }

    override func tearDown() {
        tokenGranter = nil
        super.tearDown()
    }

    func testSetUsernameAndPassword() {
        let setResult = tokenGranter.set_username_and_password(username: self.username, password: self.password)
        
        print("TEST HERE", self.username, self.password
        )
        XCTAssertTrue(setResult, "set_username_and_password should return true")
    }

    func testGrantAccessToken() async {
        let result = await tokenGranter.grant_access_token()
        XCTAssertTrue(result, "grant_access_token should return true")
    }

    func testValidateAccessToken() async {
        let isValid = await tokenGranter.validate_access_token()
        XCTAssertTrue(isValid, "validate_access_token should return true")
    }
}
