//
//  NavigationList.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI

struct NavigationButtonList: View {
    @ObservedObject var navigationListVM: NavigationListViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            ForEach(navigationListVM.navigations) { navigation in
                Button {
                    navigationListVM.setSelectedNavigation(to: navigation.id)
                } label: {
                    VStack {
                        Image(systemName: navigation.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 40)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(width: 60, height: 60)

                        Text(navigation.name)
                            .font(.caption)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 80)
                            .padding(.top, 5)
                            .foregroundColor(Color.primary)

                    }
                    .contentShape(Rectangle())
                }
            }
        }
        .padding(.leading, 8)
        .padding(.vertical)
    }
}

struct NavigationList: View {
    @StateObject var navigationListVM = NavigationListViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Section(header:
                VStack(alignment: .leading) {
                    Text("Navigate Around")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Where do you want to go?")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            ) {
             
                ScrollView(.horizontal, showsIndicators: false) {
                    NavigationButtonList(
                        navigationListVM: navigationListVM
                    )
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .onChange(of: navigationListVM.selectedNavigation) {
                    navigationListVM.isCompassOpen.toggle()
                }
                .fullScreenCover(isPresented: $navigationListVM.isCompassOpen) {
                        CompassView(
                            isCompassOpen: $navigationListVM.isCompassOpen,
                            selectedLocation: navigationListVM.selectedNavigation,
                            longitude: 0,
                            latitude: 0
                        )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
