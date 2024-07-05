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
    @State private var searchText: String = ""

    @State private var isLoading: Bool = false
    
    func filterFileNames(searchText: String) -> [String] {
        if searchText.isEmpty {
            return  fileNames
        } else {
            return  fileNames.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    

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
           .searchable(text: $searchText, prompt: "Search files")
           .onChange(of: searchText) {
               self.filteredFileNames = filterFileNames(searchText: searchText)
           }
           .task {
               self.isLoading = true

               let response = await ObsidianFileRetriever.shared.getFileList()
               self.fileNames = response.file_names ?? [""]
               self.filteredFileNames = filterFileNames(searchText: self.searchText)
               
               self.isLoading = false
           }
           
       }
    }
}

#Preview {
    MainView()
}
