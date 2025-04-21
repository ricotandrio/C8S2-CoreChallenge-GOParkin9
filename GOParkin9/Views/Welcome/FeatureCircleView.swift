//
//  FeatureCircleView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import SwiftUI

struct FeatureCircleView: View {
    let icon: String
    let caption: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.blue)
            }

            Text(caption)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
    }
}

