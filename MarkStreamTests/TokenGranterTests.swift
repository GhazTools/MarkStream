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

    override func setUp() {
        super.setUp()
        // Initialize TokenGranter with test data
        tokenGranter = TokenGranter(username: "some_user", password: "some_password")
    }

    override func tearDown() {
        tokenGranter = nil
        super.tearDown()
    }

    func testSetUsernameAndPassword() {
        let setResult = tokenGranter.set_username_and_password(username: "some_user", password: "some_password")
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
