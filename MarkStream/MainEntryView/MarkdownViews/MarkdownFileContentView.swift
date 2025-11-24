//
//  MarkdownFileContentView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/4/24.
//

import SwiftUI

struct MarkdownFileContentView: View {
    var fileName: String
    
    @StateObject private var viewModel = MarkdownFileContentViewModel()
    
    public func linesToCodeString(lines: [String]) -> String {
        var codeString: String = ""
        
        for (index, line) in lines.enumerated() {
            if(index == 0 || index == lines.count - 1) {
                continue
            }
            codeString += line + "\n"
            
        }

        return codeString
    }
    
    var body: some View {
        ScrollView{
            if viewModel.isLoading {
                LoadingView(isLoading: .constant(true))
            }
            else {
                ForEach(viewModel.items, id: \.self) { data in
                    let data_attribute = data.attribute
                    
                    switch data_attribute {
                    case "list":
                        MarkdownContentListView(mdList: data.lines)
                    case "code-block":
                        MarkdownContentCodeBlockView(codeString: linesToCodeString(lines: data.lines), language: data.information.first ?? "", theme: THEMES[7])
                    default:
                        MarkdownContentOtherView(lines: data.lines, attribute: data.attribute, information: data.information.first ?? "")
                    }
                }
            }
        }
        .task {
            await viewModel.load(fileName: fileName)
        }
    }
}

#Preview {
    MarkdownFileContentView(fileName: "How To Create A Theme   - Visual Studio Code")
        .preferredColorScheme(.dark)
}
