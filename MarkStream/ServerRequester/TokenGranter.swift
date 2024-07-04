//
//  tokenGranter.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 6/29/24.
//

import Foundation
import Alamofire

struct GrantTokenRequest: Encodable {
    let username: String
    let password: String
    let bool: Bool
};

struct GrantTokenResponse: Decodable {
    let token: String
};


struct ValidateTokenRequest: Encodable {
    let username: String
    let token: String
};

struct ValidateTokenResponse: Decodable  {
    let ErrorCode: Int
    let ErrorString: String
};


class TokenGranter {
    static let shared = TokenGranter(username: nil, password: nil)
    private var _token_granter_url: String = "https://token.ghaz.dev:440"

    private var _username: String;
    private var _password: String;
    private var _token: String;
    
    
    init(username: String?, password: String?) {
        
        self._username = username ?? KeychainManager.shared.value(forKey: KeychainKeys.username) ?? "";
        self._password = password ?? KeychainManager.shared.value(forKey: KeychainKeys.password) ?? "";

        self._token = "";
    }
    
    public func username() -> String {
        return self._username;
    }
    
    public func password() -> String {
        return self._password;
    }
    
    public func token() -> String {
        self._token;
    }
    
    
    public func set_username_and_password(username: String, password: String) -> Bool {
        if(self.username().isEmpty || self.password().isEmpty){
            return false;
        }
        
        self._username = username;
        self._password = password;
        
        return true;
    }
    
    public func grant_access_token() async -> Bool {
        if self._username.isEmpty || self._password.isEmpty {
            print("INVALID USERNAME & TOKEN")
            return false
        }
        
        let success = await make_grant_access_token_rquest()
        return success
    }
    
    
    public func validate_access_token() async -> Bool {
        if self._username.isEmpty || self._password.isEmpty {
            print("INVALID USERNAME")
            return false;
        }
        
        if self._token.isEmpty && !self._username.isEmpty && !self._password.isEmpty{
            let success = await self.make_grant_access_token_rquest()
            if(!success){
                return false;
            }
        }
        
        
        return await make_validate_access_token_request();
    }
    
    
    // PRIVATE FUNCTIONS START HERE
    private func make_grant_access_token_rquest() async -> Bool {
        let grantTokenRequest = GrantTokenRequest(username: self._username, password: self._password, bool: false)
        let grantTokenUrl: String = "\(self._token_granter_url)/token/grant"
                
        
        return await withCheckedContinuation { continuation in
            AF.request(
                grantTokenUrl,
                method: .post,
                parameters: grantTokenRequest,
                encoder: JSONParameterEncoder.default
            ).responseDecodable(of: GrantTokenResponse.self) { response in
                switch response.result {
                case .success(let grantTokenResponse):
                    self._token = grantTokenResponse.token
                    continuation.resume(returning: true)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self._token = ""
                    continuation.resume(returning: false)
                }
            }
        }
//        
//        return await withCheckedContinuation { continuation in
//            AF.request(
//                grantTokenUrl,
//                method: .post,
//                parameters: grantTokenRequest,
//                encoder: JSONParameterEncoder.default
//            ).responseString { response in
//                switch response.result {
//                case .success(let jsonString):
//                    print("Raw JSON String: \(jsonString)")
//                    // Optionally, manually decode jsonString to GrantTokenResponse here
//                    do {
//                        let jsonData = Data(jsonString.utf8)
//                        let grantTokenResponse = try JSONDecoder().decode(GrantTokenResponse.self, from: jsonData)
//                        self._token = grantTokenResponse.token
//                        continuation.resume(returning: true)
//                    } catch {
//                        print("Decoding Error: \(error.localizedDescription)")
//                        self._token = ""
//                        continuation.resume(returning: false)
//                    }
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                    self._token = ""
//                    continuation.resume(returning: false)
//                }
//            }
//        }
    }
    
    private func make_validate_access_token_request() async -> Bool {
        let validateTokenRequest = ValidateTokenRequest(username: self._username, token: self._token)
        let validateTokenUrl: String = "\(self._token_granter_url)/token/validate"
        
        return await withCheckedContinuation { continuation in
            AF.request(
                validateTokenUrl,
                method: .post,
                parameters: validateTokenRequest,
                encoder: JSONParameterEncoder.default
            ).responseDecodable(of: ValidateTokenResponse.self) { [weak self] response in
                switch response.result {
                case .success(let validateTokenResponse):
                    let errorCode: Int = validateTokenResponse.ErrorCode
                    
                    if errorCode == 2 {
                        Task {
                            // Capture 'self' weakly to avoid retain cycles
                            [weak self] in
                            guard let strongSelf = self else {
                                continuation.resume(returning: false)
                                return
                            }
                            let granted = await strongSelf.grant_access_token()
                            continuation.resume(returning: granted)
                        }
                    } else {
                        continuation.resume(returning: errorCode == 0)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
}
