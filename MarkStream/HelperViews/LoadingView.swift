//
//  LoadingView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 7/4/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack {
            if self.isLoading {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.ghazBlue))
                            .scaleEffect(2) // Makes the spinner larger
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}


struct Loadingiew_Previews: PreviewProvider {
    struct LoadingreviewWrapper: View {
        @State private var isLoading: Bool = true

        var body: some View {
            LoadingView(isLoading: $isLoading)
                .preferredColorScheme(.dark)
        }
    }

    
    static var previews: some View {
        LoadingreviewWrapper()
    }
}
