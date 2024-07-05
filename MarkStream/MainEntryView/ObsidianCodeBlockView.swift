//
//  MarkdownCodeBlockView.swift
//  Kato
//
//  Created by Ghazanfar Shahbaz on 9/13/23.
//

import SwiftUI
import Highlightr


// https://github.com/raspu/Highlightr
// https://sarunw.com/posts/how-to-convert-between-nsattributedstring-and-attributedstring/

let THEMES: [String] = ["vs", "atelier-seaside-dark", "isbl-editor-dark", "brown-paper", "atelier-plateau-light", "school-book", "xcode", "atelier-sulphurpool-dark", "tomorrow-night-blue", "vs2015", "atelier-heath-dark", "paraiso-light", "rainbow", "qtcreator_light", "a11y-light", "kimbie.dark", "atelier-heath-light", "far", "atelier-dune-dark", "shades-of-purple", "kimbie.light", "railscasts", "solarized-dark", "atelier-estuary-light", "xt256", "mono-blue", "ocean", "github-gist", "atelier-seaside-light", "tomorrow-night-eighties", "atom-one-dark", "qtcreator_dark", "atelier-savanna-dark", "color-brewer", "pojoaque", "routeros", "atelier-forest-dark", "gml", "tomorrow-night", "obsidian", "lightfair", "atelier-lakeside-dark", "gruvbox-light", "idea", "tomorrow", "atelier-forest-light", "arduino-light", "gruvbox-dark", "dracula", "magula", "arta", "purebasic", "hopscotch", "github", "nord", "dark", "atom-one-light", "monokai", "docco", "default", "ascetic", "isbl-editor-light", "atelier-cave-light", "a11y-dark", "atelier-sulphurpool-light", "atelier-plateau-dark", "darkula", "atelier-cave-dark", "ir-black", "solarized-light", "tomorrow-night-bright", "atelier-savanna-light", "foundation", "codepen-embed", "atelier-estuary-dark", "googlecode", "atom-one-dark-reasonable", "atelier-dune-light", "paraiso-dark", "zenburn", "androidstudio", "grayscale", "sunburst", "agate", "hybrid", "darcula", "atelier-lakeside-light", "monokai-sublime", "an-old-hope"]


struct MarkdownCodeBlockView: View {
    @State var codeString: String
    let highlightr = Highlightr()
    @State var language: String
    @State private var highlightedCode: NSAttributedString = NSAttributedString(string: "")
    @State var theme: String
    
    var body: some View {

        HStack{

            VStack{
                HStack{
//                    Image(systemName: "textformat.size.smaller")
//                        .foregroundColor(titleColor)
                    
                    Picker("Themes", selection: $theme) {
                        ForEach(THEMES, id: \.self) {
                            Text($0)
//                                .foregroundColor(titleColor)
                                .fontWeight(.heavy)
                                .font(.subheadline)
                        }
                    }
                    .onChange(of: theme) { newTheme, _ in
                        highlightr?.setTheme(to: newTheme) // Use newTheme directly

                        highlightedCode = highlightr?.highlight(codeString) ?? NSAttributedString(string: "")
                    }
                    Spacer()
                    Text(language)
//                        .foregroundColor(titleColor)
                        .font(.subheadline)

                }
                .padding([.leading,.trailing])
                .padding(.top, 5)
                
                Divider()
//                    .overlay(headlineColor)
//                    .background(headlineColor)
                    .padding([.leading,.trailing])

                HStack{
                    Text(AttributedString(highlightedCode))
                        .font(.system(.subheadline, design: .monospaced))
                        .padding()
                    Spacer()
                }
            }
        }
//        .background(codeBlockColor)
        .cornerRadius(10)
        .padding()
        .task {
            highlightr?.setTheme(to: theme) // or obsidian

            highlightedCode = highlightr?.highlight(codeString) ?? NSAttributedString(string: "")
        }



    }
}

struct MarkdownCodeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownCodeBlockView(codeString:
            """
            import test
            from test import abc

            for x in range(10):
                print(x)
                assert abc(a) == "b"
            """,
            language: "python",
            theme: THEMES[7]
//            import test\n\tprint(test.value)\n\t#test"
//        )
        ).preferredColorScheme(.dark)
    }
}
