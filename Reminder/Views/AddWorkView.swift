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
                            title = "새로운 미리 알림"
                        }
                        let work = Work(title: title, memo: memo, dueDate: dueDate)
                        modelContext.insert(work)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddWorkView()
}
