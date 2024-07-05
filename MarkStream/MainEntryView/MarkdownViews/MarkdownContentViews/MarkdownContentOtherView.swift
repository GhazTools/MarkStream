//
//  MarkdownContentOtherView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/4/24.
//

import SwiftUI

struct MarkdownContentOtherView: View {
    @State var lines: [String]
    @State var attribute: String
    @State var information: String
    
    let textStrings: Set = ["text", "h"]

    var body: some View {
        if textStrings.contains(attribute) {
            VStack(alignment: .leading) {
                ForEach(lines, id: \.self) { line in
                    if let attributeLine = try? AttributedString(markdown: line) {
                        if attribute == "text" {
                            Text(attributeLine)
                                .foregroundColor(Color.ghazGray)
                                .padding([.leading, .trailing])
                        } else if attribute == "h" {
                            let infoInt = Int(information) ?? 0
                            
                            switch infoInt {
                                case 1:
                                    Text(attributeLine)
                                        .fontWeight(.black)
                                    Divider()
                                case 2:
                                    Text(attributeLine)
                                        .fontWeight(.black)
                                        .foregroundColor(Color.ghazBlue)
                                    Divider()
                                case 3:
                                    Text(attributeLine)
                                        .fontWeight(.black)
                                        .foregroundColor(Color.ghazYellow)
                                    Divider()
                                default:
                                    EmptyView()
                            }
                        }
                    }
                }
            }
        } else {
            // Handle the case where attribute is not in textStrings
            EmptyView()
        }
    }
}

struct MarkdownContentOtherView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MarkdownContentOtherView(lines: ["This is regular text"], attribute: "text", information: "")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("RegularText")

            MarkdownContentOtherView(lines: ["This is a h1"], attribute: "h", information: "1")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Header1")


            MarkdownContentOtherView(lines: ["This is a h2"], attribute: "h", information: "2")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Header2")

            MarkdownContentOtherView(lines: ["This is a h3"], attribute: "h", information: "3")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Header3")
        }
    }
}
