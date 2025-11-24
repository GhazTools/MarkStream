import Foundation

// Protocol to abstract the Obsidian file retrieval service for testability and clearer structure.
protocol ObsidianFileRetrieving {
    func getFileList() async -> GetFileListResponse
    func getFileContents(file_name: String) async -> GetFileContentsResponse
    func getFileContentsDetailed(file_name: String) async -> GetFileContentsDetailedResponse
}

// Conform existing service to the protocol without changing behavior.
extension ObsidianFileRetriever: ObsidianFileRetrieving {}
