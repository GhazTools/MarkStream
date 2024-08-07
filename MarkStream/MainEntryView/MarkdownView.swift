//
//  ObsidianMarkdownView.swift
//  Kato
//
//  Created by Ghazanfar Shahbaz on 8/27/23.
//

import SwiftUI
import UIKit


struct MarkdownCodeBlockInit: View {
    @State var lines: [String] = []
    @State var information: [String] = []
    @State var theme: String
    
    
//    public func createCodeString() -> String {
//        var codeString: String = ""
//        
//        for (index, line) in lines.enumerated() {
//            if(index == 0 || index == lines.count){
//                continue
//            }
//            codeString += line + "\n"
//            
//        }
//
//        return codeString
//    }
//    
    
    var body: some View {
        Text("TEST")
//        MarkdownCodeBlockView(codeString: createCodeString(), language: information[0], theme: theme)
    }

}

struct MarkdownList: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @State var mdList: [String] = []
    
    
    var body: some View {
        let count: CGFloat = CGFloat(mdList.count) * 1.75

        List {
            ForEach(mdList, id: \.self) { line in
                let attributeLine : AttributedString = try! AttributedString(
                    markdown: line ,
                    options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                            .inlineOnlyPreservingWhitespace)
                )
                
                Text(attributeLine)
            }
        }
        .frame(minHeight: minRowHeight * count)
    }
}

struct MarkdownObjectView: View {
    @State var lines: [String]
    @State var attribute: String
    
    let textStrings: Set = ["text", "h1", "h2", "h3"]


    var body: some View {
        if(textStrings.contains(attribute)){
            VStack(alignment: .leading){
                ForEach(lines, id: \.self) { line in
                    let attributeLine : AttributedString = try! AttributedString(
                        markdown: line ,
                        options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                .inlineOnlyPreservingWhitespace)
                    )
                    
                    if(attribute == "text"){
                        Text(attributeLine)
                        
                    }
                    else if(attribute == "h1"){
                        Text(attributeLine)
                            .fontWeight(.black)
                        Divider()
                    }
                    else if(attribute == "h2"){
                        Text(attributeLine)
                            .fontWeight(.black)
                        Divider()
                    }
                    else if(attribute == "h3"){
                        Text(attributeLine)
                            .fontWeight(.black)
                        Divider()
                    }
                }
                
            }
        }
    }
}



struct ObsidianMarkdownView: View {
    var fileName: String
    @State var markdownContents: AttributedString = try! AttributedString(markdown: "Loading", options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
            .inlineOnlyPreservingWhitespace))
    
    struct fileContentsDetailed: Identifiable, Codable, Hashable {
        var id = UUID()
        var lines: [String]
        var attribute: String
    }
    
    @State var theme: String = ""
    @State var markdownDetailedContents: [fileContentsDetailed] = []
    
    public func getFileContents() async {

        let markdownContentsDetailedDS: GetFileContentsDetailedResponse = await ObsidianFileRetriever.shared.getFileContentsDetailed(file_name: fileName)
                
    
        for data in markdownContentsDetailedDS.file_contents ?? [] {
            markdownDetailedContents.append(
                fileContentsDetailed(
                    lines: data._lines,
                    attribute: data._attribute
                )
            )
        }
    }
    
    public func createCodeString(lines: [String]) -> String {
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
        VStack{
            HStack {
                Text("Markdown View")
                    .fontWeight(.heavy)
                Button(action: {
                    Task {
                        await getFileContents()
                    }
                }) {
                    Text("Reload")
                        .fontWeight(.black)
                        .padding()
                }
            }
        
            
            Divider()

            HStack{
                Text(fileName)
                    .fontWeight(.black)
                
                    Label("", systemImage: "pencil")
                }
            }
        
        
        ScrollView{
            ForEach(markdownDetailedContents, id: \.self) { data in
                if(data.attribute == "list"){
                    MarkdownList(mdList: data.lines)
                }
                else {
                    MarkdownObjectView(lines: data.lines, attribute: data.attribute)
                }
            }
        }
    }
}

struct ObsidianMarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        ObsidianMarkdownView(fileName: "How To Create A Theme   - Visual Studio Code")
            .preferredColorScheme(.dark)
    }
}
