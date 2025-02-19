//
//  Work.swift
//  Reminder
//
//  Created by mwpark on 1/22/25.
//

import Foundation
import SwiftData

@Model
final class Work {
    var title: String
    var memo: String
    var isCompleted: Bool
    var isDeleted: Bool
    var dueDate: Date
    var createdAt: Date
    var deletedAt: Date?
    var myList: String
    
    init(title: String = "",
         memo: String = "",
         isCompleted: Bool = false,
         dueDate: Date = Date(),
         createdAt: Date = Date(), isDeleted: Bool = false, myList: String = "") {
        self.title = title
        self.isCompleted = isCompleted
        self.memo = memo
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.isDeleted = isDeleted
        self.myList = myList
    }
}
