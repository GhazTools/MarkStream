//
//  ObsidianFileContentView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/3/24.
//

import SwiftUI


struct ObsidianFileContentView: View {
    var fileName: String
    @State var fileContents: String = "";

    var body: some View {
        Text("Opening file: \(fileName)")
            .navigationBarTitle(fileName, displayMode: .inline)
        
        Text(fileContents)
            .onAppear {
                Task {
                    let response = await ObsidianFileRetriever.shared.getFileContents(file_name: self.fileName )
                    self.fileContents = response.file_contents
                }
            }
    }
}

#Preview {
    ObsidianFileContentView(fileName: "TEST")
}
