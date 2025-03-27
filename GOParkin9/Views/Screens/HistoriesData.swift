//
//  HistoriesData.swift
//  GOParkin9
//
//  Created by Chikmah on 27/03/25.
//

import Foundation

struct HistoriesData: Identifiable  {
    var id = UUID()
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy" // Example: "28 March 2025"
        return formatter.string(from: Date())
    }
    var clockInHour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // 12-hour format
        return formatter.string(from: Date())
    }
    var clockOutHour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: Date())
    }
    
    var images: [Data]
}

/*
let testData = [
    HistoriesData(date: "28 March 2025", clockInHour: "08:40 AM", clockOutHour: "17:03 PM", images: [])
]
*/
