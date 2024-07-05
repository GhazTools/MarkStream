//
//  MarkdownContentListView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/4/24.
//

import SwiftUI

struct MarkdownContentListView: View {
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

#Preview {
    MarkdownContentListView(mdList: ["Object 1", "Object 2", "Object 3"])
}
