//
//  ObsidianRequester.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/1/24.
//

import Foundation
import Alamofire

struct ObsidianFileRetrieverEndpoints {
    static let getFileList = "getFileList"
    static let getFileContents =  "getFileContents"
    static let geFileContentsDetailed = "getFileContentsDetailed"
};


// GET FILE LIST STARTS HERE
struct GetFileRquest: Encodable {
    let user: String;
    let token: String;
};

struct GetFileListResponse: Decodable {
    var file_names: [String]?
};

let ERROR_GET_FILE_RESPONSE: GetFileListResponse = GetFileListResponse(file_names: []);
// GET FILE LIST ENDS HERE

// GET FILE CONTENTS STARTS HERE
struct GetFileContentsRequest: Encodable {
    let user: String;
    let token: String;
    let fileName: String;
};

struct GetFileContentsResponse: Decodable {
    let file_contents: String;
};

let ERROR_GET_FILE_CONTENTS_RESPONSE: GetFileContentsResponse = GetFileContentsResponse(file_contents: "");
// GET FILE CONTENTS END HERE

// GET FILE CONTENTS DETAILED STARTS HERE
struct GetFileContentsDetailedRequest: Encodable {
    let user: String;
    let token: String;
    let fileName: String;
};

struct GetFileContentsDetailedResponse: Decodable {
    struct markdown_object: Codable {
        var _lines: [String]
        var _index: Int
        var _attribute: String
        var _raw_line: [String]
        var _information: [String]
    };
    
    var file_contents: [markdown_object]?;
};

let ERROR_GET_FILE_CONTENTS_DETAILED_RESPONSE: GetFileContentsDetailedResponse = GetFileContentsDetailedResponse(file_contents: []);
// GET FILE CONTENTS DETAILED END HERE

class ObsidianFileRetriever {
    static let shared = ObsidianFileRetriever();
    private let _obsidian_file_retriever_url: String = "https://www.obsidianfileretrieversvc.ghaz.dev:440"
    
    init() {}
    
    public func getFileList() async -> GetFileListResponse {
        let valid_token: Bool =  await TokenGranter.shared.grant_access_token()

        if !valid_token {
            return ERROR_GET_FILE_RESPONSE
        }
        
        let getFileListRequest = GetFileRquest(user: TokenGranter.shared.username(), token: TokenGranter.shared.token())
        let requestUrl: String = "\(self._obsidian_file_retriever_url)/\(ObsidianFileRetrieverEndpoints.getFileList)"

    
        return await withCheckedContinuation { continuation in
            AF.request(
                requestUrl,
                method: .post,
                parameters: getFileListRequest,
                encoder: JSONParameterEncoder.default
            ).responseDecodable(of: GetFileListResponse.self) { response in
                switch response.result {
                case .success(let getFileResponse):
                    continuation.resume(returning: getFileResponse)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    continuation.resume(returning: ERROR_GET_FILE_RESPONSE)
                }
            }
        }
    }
    
    
    public func getFileContents(file_name: String) async -> GetFileContentsResponse {
        let valid_token: Bool =  await TokenGranter.shared.grant_access_token()

        if !valid_token {
            return ERROR_GET_FILE_CONTENTS_RESPONSE
        }
        
        let getFileContentsRequest = GetFileContentsRequest(user: TokenGranter.shared.username(), token: TokenGranter.shared.token(), fileName: file_name)
        let requestUrl: String = "\(self._obsidian_file_retriever_url)/\(ObsidianFileRetrieverEndpoints.getFileContents)"

    
        return await withCheckedContinuation { continuation in
            AF.request(
                requestUrl,
                method: .post,
                parameters: getFileContentsRequest,
                encoder: JSONParameterEncoder.default
            ).responseDecodable(of: GetFileContentsResponse.self) { response in
                switch response.result {
                case .success(let getFileContentsResponse):
                    continuation.resume(returning: getFileContentsResponse)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    continuation.resume(returning: ERROR_GET_FILE_CONTENTS_RESPONSE)
                }
            }
        }
    }
    
    public func getFileContentsDetailed(file_name: String) async -> GetFileContentsDetailedResponse {
        let valid_token: Bool =  await TokenGranter.shared.grant_access_token()

        if !valid_token {
            
            return ERROR_GET_FILE_CONTENTS_DETAILED_RESPONSE
        }
        
        let getFileContentsDetailedRequest = GetFileContentsDetailedRequest(user: TokenGranter.shared.username(), token: TokenGranter.shared.token(), fileName: file_name)
        let requestUrl: String = "\(self._obsidian_file_retriever_url)/\(ObsidianFileRetrieverEndpoints.geFileContentsDetailed)"

    
        return await withCheckedContinuation { continuation in
            AF.request(
                requestUrl,
                method: .post,
                parameters: getFileContentsDetailedRequest,
                encoder: JSONParameterEncoder.default
            ).responseDecodable(of: GetFileContentsDetailedResponse.self) { response in
                switch response.result {
                case .success(let getFileContentsDetailedResponse):
                    continuation.resume(returning: getFileContentsDetailedResponse)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    continuation.resume(returning: ERROR_GET_FILE_CONTENTS_DETAILED_RESPONSE)
                }
            }
        }
    }
}
