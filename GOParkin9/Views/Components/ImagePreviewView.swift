//
//  ImagePreviewView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI

struct ImagePreviewView: View {
    let imageName: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    isPresented = false
                }
        }
    }
}
