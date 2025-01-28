//
//  EditWorkView.swift
//  Reminder
//
//  Created by mwpark on 1/25/25.
//

import SwiftUI

struct EditWorkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var counts: Counts
    
    var work: Work
    
    @State private var title: String
    @State private var memo: String
    @State private var dueDate: Date
    @State var editMode: Int
    
    init(work: Work, editMode: Int = 0) {
        self.work = work
        self.title = work.title
        self.memo = work.memo
        self.dueDate = work.dueDate
        self.editMode = editMode
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
                        dueDate
                    }, set: {
                        dueDate = $0
                    }))
                }
            }
            .navigationTitle("세부사항")
            .toolbar {
                if editMode == 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("취소") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        work.title = title
                        work.memo = memo
                        work.dueDate = dueDate
                        dismiss()
                    }
                }
            }
            
        }
    }
}
