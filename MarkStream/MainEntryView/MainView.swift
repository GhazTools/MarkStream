//
//  MainView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/1/24.
//

import SwiftUI

struct MainView: View {
    @State private var fileNames: [String] = []

       var body: some View {
           NavigationView {
               
               List(self.fileNames, id: \.self) { fileName in
                   NavigationLink(destination: MarkdownFileView(fileName: fileName)) {
                       Text(fileName)
                   }
               }
               
               .onAppear {
                   Task {
                       // Simulate fetching data asynchronously
                       // Replace this with your actual data fetching logic
                       let response = await ObsidianFileRetriever.shared.getFileList()
                       self.fileNames = response.file_names ?? ["TEST"]
                   }
               }
           }
       }
}

#Preview {
    MainView()
}
