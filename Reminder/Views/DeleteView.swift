//
//  DeleteView.swift
//  Reminder
//
//  Created by mwpark on 1/29/25.
//

import SwiftUI
import SwiftData

struct DeleteView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var works: [Work]
    @EnvironmentObject var counts: Counts
    
    init() {
        let predicate = #Predicate<Work> {
            $0.isDeleted == true
        }
        _works = Query(filter: predicate, sort: [SortDescriptor(\Work.dueDate)])
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("최근 삭제된 항목")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            VStack {
                HStack {
                    Text("미리 알림이 여기서 30일 동안 유지됩니다.")
                    Spacer()
                }
                HStack {
                    Text("해당 기간이 지나면 미리 알림은 영구적으로 삭제됩니다.")
                        .lineLimit(1)
                    Spacer()
                }
            }
            .foregroundStyle(.gray)
            .padding(.leading)
            List {
                ForEach(works) { work in
                    WorkRowView(work: work, isDeleting: true)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive){
                                modelContext.delete(work)
                            }
                            label: { Text("삭제") }
                                .tint(.red)
                            Button(action: {
                                work.isDeleted = false
                            }, label: {
                                Text("이동")
                            })
                            .tint(.purple)
                        }
                }
            }
            Spacer()
        }
        .onAppear(perform: {
            for work in works {
                if work.deletedAt != nil && Date().timeIntervalSince(work.deletedAt!) >= 2592000 {
                    modelContext.delete(work)
                }
            }
        })
    }
}

#Preview {
    DeleteView()
        .environmentObject(Counts())
}
