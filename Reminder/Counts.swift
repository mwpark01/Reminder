//
//  Counts.swift
//  Reminder
//
//  Created by mwpark on 1/26/25.
//

import Foundation

class Counts: ObservableObject {
    @Published var todayCount: Int = 0
    @Published var expectedDayCount: Int = 0
    @Published var allCount: Int = 0
    @Published var completedWorkCount: Int = 0
    @Published var deletedWorkCount: Int = 0
}
