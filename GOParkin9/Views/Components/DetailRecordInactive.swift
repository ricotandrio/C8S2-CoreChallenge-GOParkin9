//
//  DetailRecordInactive.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI

struct DetailRecordInactive: View {
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
                .frame(height: 80)
            
            Image(systemName: "parkingsign.radiowaves.left.and.right.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.gray)
            
//            Text("There's no active parking record. Try to park your vehicle.")
//                .padding(.horizontal, 30)
//                .font(.subheadline)
//                .fontWeight(.bold)
//                .opacity(0.6)
//                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 80)
            
            Button {
                print("Park Now")
                showingSheet.toggle()
            } label: {
                HStack {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                    
                    Text("Park Now")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .sheet(isPresented: $showingSheet) {
                ModalView()
            }
        }
    }
}
