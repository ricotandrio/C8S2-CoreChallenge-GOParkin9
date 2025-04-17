//
//  ConfigAutomaticDeleteView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 31/03/25.
//

import SwiftUI

struct ConfigAutomaticDeleteView: View {
    @EnvironmentObject private var userSettingsVM: UserSettingsViewModel

    let options: [Int] = [1, 3, 5, 7, 14, 30, 60, 90]
    
    var body: some View {
        List {
            Section(header: Text("Delete History After")) {
                ForEach(options, id: \.self) { option in
                    HStack {
                        Text("\(option) Days\(option == 5 ?  " (Default)" : "")")
                        Spacer()
                        if userSettingsVM.daysBeforeAutomaticDelete == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        userSettingsVM.setDaysBeforeAutomaticDelete(to: option)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
