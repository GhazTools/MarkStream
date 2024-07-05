//
//  MainView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/1/24.
//

import SwiftUI

struct MainView: View {
    @State private var fileNames: [String] = []
    @State private var filteredFileNames: [String] = []
    @State private var searchText: String = "" // 1. Add search text state

    @State private var isLoading: Bool = false

       var body: some View {
           NavigationView {
               VStack{
                   if (self.isLoading) {
                       LoadingView(isLoading: self.$isLoading)
                   }
                   
                   List(self.filteredFileNames, id: \.self) { fileName in
                       NavigationLink(destination: MarkdownFileView(fileName: fileName)) {
                           Text(fileName)
                       }
                   }
               }
               .searchable(text: $searchText, prompt: "Search files") // 2. Add searchable modifier
               .onChange(of: searchText) {
                   if searchText.isEmpty {
                       self.filteredFileNames = fileNames
                   } else {
                       self.filteredFileNames = fileNames.filter { $0.lowercased().contains(searchText.lowercased()) }
                   }
               }
               .task {
                   self.isLoading = true

                   let response = await ObsidianFileRetriever.shared.getFileList()
                   self.fileNames = response.file_names ?? [""]
                   self.filteredFileNames = self.fileNames

                   
                   self.isLoading = false
               }
               
           }
       }
}

#Preview {
    MainView()
}
