//
//  EditWorkView.swift
//  Reminder
//
//  Created by mwpark on 1/25/25.
//

import SwiftUI
import SwiftData

struct EditWorkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var counts: Counts
    @Query private var works: [Work]
    @Query private var myLists: [MyList]
    var _work: Work
    
    @State private var title: String
    @State private var memo: String
    @State private var dueDate: Date
    @State var editMode: Int
    @State var selectedMyList: MyList?
    
    init(_work: Work, editMode: Int = 0) {
        self._work = _work
        self.title = _work.title
        self.memo = _work.memo
        self.dueDate = _work.dueDate
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
                
                Section() {
                    Picker(selection: $selectedMyList) {
                        Text("선택안함").tag(Optional<MyList>.none)
                        ForEach(myLists) { myList in
                            Text(myList.content).tag(Optional(myList))
                        }
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(selectedMyList?.setColor ?? Color.white)
                                .overlay(content: {
                                    Image(systemName: selectedMyList?.setSystemImages ?? "circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 20, height: 20)
                                })
                            Text("목록")
                        }
                    }
                    .onAppear {
                        if let selectedItem = myLists.first(where: { $0.content == _work.myList }) {
                            selectedMyList = selectedItem
                        } else {
                            // 해당 항목이 없을 경우 처리
                            selectedMyList = nil
                        }
                    }
                }
            }
            .navigationTitle("세부사항")
            .toolbar {
                // sheet에서 실행할 때
                if editMode == 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("취소") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        _work.title = title
                        _work.memo = memo
                        _work.dueDate = dueDate
                        _work.myList = selectedMyList?.content ?? ""
                        reloadData()
                        dismiss()
                    }
                }
            }
        }
    }
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

