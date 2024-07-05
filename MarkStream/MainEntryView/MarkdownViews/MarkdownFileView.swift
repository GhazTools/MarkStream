//
//  MarkdownFileView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/4/24.
//

import SwiftUI

struct MarkdownFileView: View {
    var fileName: String
    
    var body: some View {
        MarkdownFileHeaderView(fileName: fileName)
        MarkdownFileContentView(fileName: fileName)
    }
}

#Preview {
    MarkdownFileView(fileName: "Some File Here")
        .preferredColorScheme(.dark)
}
