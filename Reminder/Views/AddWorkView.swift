//
//  AddWorkView.swift
//  Reminder
//
//  Created by mwpark on 1/22/25.
//

import SwiftUI
import SwiftData

struct AddWorkView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var counts: Counts
    @Query private var works: [Work]
    @State private var title: String
    @State private var memo: String
    @State private var dueDate: Date
    
    init(title: String = "", memo: String = "", dueDate: Date = Date()) {
        self.title = title
        self.memo = memo
        self.dueDate = dueDate
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("제목", text: $title)
                    TextField("메모", text: $memo)
                }
                Section {
                    DatePicker("마감일",
                               selection: Binding(get: {
                        Date()
                    }, set: {
                        dueDate = $0
                    }))
                }
            }
            .navigationTitle("일정 추가")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        if title.isEmpty {
                            title = "새로운 미리 알림 \(counts.allCount + 1)"
                        }
                        let work = Work(title: title, memo: memo, dueDate: dueDate)
                        modelContext.insert(work)
                        reloadData()
                        dismiss()
                    }
                }
            }
        }
    }
    
    // 값 변경 함수
    func reloadData() {
        let current = Calendar.current
        counts.allCount = 0
        counts.completedWorkCount = 0
        counts.expectedDayCount = 0
        counts.todayCount = 0
        counts.deletedWorkCount = 0
        
        for work in works {
            if work.isDeleted {
                counts.deletedWorkCount += 1
            } else {
                counts.allCount += 1
                if work.isCompleted {
                    counts.completedWorkCount += 1
                }
                if current.isDateInToday(work.dueDate) {
                    counts.todayCount += 1
                }
                if work.dueDate > Date() {
                    counts.expectedDayCount += 1
                }
            }
        }
    }
}

#Preview {
    AddWorkView()
        .environmentObject(Counts())
}
