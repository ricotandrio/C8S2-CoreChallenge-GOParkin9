//
//  DetailHistoryView.swift
//  GOParkin9
//
//  Created by Chikmah on 07/04/25.
//

import SwiftUI

struct HistoryDetail: View {
    // Sample data
    let images = ["3CF9C512-DE75-4C62-B038-553BFBCED56A_1_105_c", "4D6A4712-F6CD-4E23-A454-8CF3FD2B12B4_1_105_c", "BAE36E3B-F571-4CAB-A27D-333964AC4452_1_105_c"]
    let date = "24 Mar 2025"
    let location = "1st Floor"
    let clockIn = "08.47 AM"
    let clockOut = "05.45 PM"

//    @Environment(\.dismiss) var dismiss // For navigation back

    var body: some View {
        VStack(spacing: 16) {
            // Image Slider
            TabView {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(10)
                }
            }
            .frame(height: 250)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            // Details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack {
                        Image(systemName: "stairs")
                        Text("\(location)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "calendar")
                        Text("\(date)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(5)
                HStack {
                    HStack {
                        Image(systemName:"arrow.down.backward.circle")
                        Text("\(clockIn)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    HStack {
                        Image(systemName:"arrow.up.forward.circle")
                        Text("\(clockOut)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(5)
            }
            .padding()
            
            // Button
            Button(action: {
            }) {Text("Navigate Back")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            HStack {
                Button(action: {
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Button(action: {
                }) {
                    HStack {
                        Image(systemName: "pin")
                        Text("Pin History")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("\(date)")
        .navigationBarTitleDisplayMode(.inline)
        
        Spacer()
    }
}


struct HistoryDetailView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("History Detail") {
                HistoryDetail()
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryDetailView()
}
