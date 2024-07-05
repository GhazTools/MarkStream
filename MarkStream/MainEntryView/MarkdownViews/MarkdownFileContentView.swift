//
//  MarkdownFileContentView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/4/24.
//

import SwiftUI

struct FileContentsDetailed: Identifiable, Codable, Hashable {
    var id = UUID()
    var lines: [String]
    var attribute: String
    var index: Int
    var information: [String]
    var raw_lins: [String]
}

struct MarkdownFileContentView: View {
    var fileName: String
    
    @State var markdownDetailedContents: [FileContentsDetailed] = []
    
    public func getFileContents() async {
        let markdownContentsDetailedResponse: GetFileContentsDetailedResponse = await ObsidianFileRetriever.shared.getFileContentsDetailed(file_name: fileName)
                
    
        for data in markdownContentsDetailedResponse.file_contents ?? [] {
            markdownDetailedContents.append(
                FileContentsDetailed(
                    lines: data._lines,
                    attribute: data._attribute,
                    index: data._index,
                    information: data._information,
                    raw_lins: data._raw_line
                )
            )
        }
    }
    
    public func linesToCodeString(lines: [String]) -> String {
        var codeString: String = ""
        
        for (index, line) in lines.enumerated() {
            if(index == 0 || index == lines.count){
                continue
            }
            codeString += line + "\n"
            
        }

        return codeString
    }
    
    var body: some View {
        ScrollView{
            ForEach($markdownDetailedContents, id: \.self) { data in
                let data_attribute = data.attribute.wrappedValue
                
                switch data_attribute {
                case "list":
                    MarkdownContentListView(mdList: data.lines.wrappedValue)
                case "code-block":
                    MarkdownContentCodeBlockView(codeString: linesToCodeString(lines: data.lines.wrappedValue), language: data.information.wrappedValue[0], theme: THEMES[7])
                default:
                    MarkdownContentOtherView(lines: data.lines.wrappedValue, attribute: data.attribute.wrappedValue, information: data.information.wrappedValue[0])

                }
            }
        }
        .task{
            await getFileContents()
        }
    }
}

#Preview {
    MarkdownFileContentView(fileName: "How To Create A Theme   - Visual Studio Code")
        .preferredColorScheme(.dark)
}
