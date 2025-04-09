//
//  DetailRecordInactive.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
 
struct DetailRecordInactive: View {
    
    @State private var showAlertSaveLocation: Bool = false
    @State private var showingSheet: Bool = false
    
    let locationManager = NavigationManager()
    @State private var savedLocation: CLLocationCoordinate2D?
    
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
                showAlertSaveLocation.toggle()
                
            } label: {
                HStack {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                    
                    Text("Mark This Spot")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            
        }
        .sheet(isPresented: $showingSheet) {
            if let location = savedLocation {
                ModalView(savedLocation: location)
            }
        }
        .alertComponent(
                    isPresented: $showAlertSaveLocation,
                    title: "Saving Location",
                    message: "Are you sure you are in your parking spot?",
                    confirmAction: {
                        savedLocation = locationManager.location?.coordinate
                    },
                    cancelButtonText: "No",
                    confirmButtonText: "Yes"
                )
                .onChange(of: savedLocation) { newValue in
                    if newValue != nil {
                        showingSheet = true
                    }
                }
        
    }
}
