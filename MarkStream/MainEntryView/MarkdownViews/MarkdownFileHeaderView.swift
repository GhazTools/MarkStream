//
//  MarkdownFileHeaderView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/4/24.
//

import SwiftUI

struct MarkdownFileHeaderView: View {
    var fileName: String
    
    var body: some View {
        VStack{
            HStack {
                Text("Markdown View")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.ghazBlue)
            }
            
            
            Divider()
            
            HStack{
                Text(fileName)
                    .fontWeight(.black)
                    .foregroundColor(.ghazGray)
                
                Label("", systemImage: "pencil")
                    .foregroundColor(.ghazYellow)
            }
        }
    }
}

#Preview {
    MarkdownFileHeaderView(fileName: "TEST")
        .preferredColorScheme(.dark)
}
