//
//  WorkRowView.swift
//  Reminder
//
//  Created by mwpark on 1/24/25.
//

import SwiftUI

struct WorkRowView: View {
    //    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var count: Counts
    @State var work: Work
    @State private var isEditing = false
    @State private var content: String = ""
    @State private var isEditingDetail: Bool = false
    @State private var isDeleting: Bool
    init(work: Work, isDeleting: Bool = false) {
        self.work = work
        self.isDeleting = isDeleting
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    work.isCompleted = !work.isCompleted
                    
                    if work.isCompleted {
                        count.completedWorkCount += 1
                    } else {
                        count.completedWorkCount -= 1
                    }
                }, label: {
                    Image(systemName: work.isCompleted ? "circlebadge.fill" :"circlebadge")
                        .resizable()
                        .foregroundStyle(work.isCompleted ? .blue : .gray)
                        .font(.title2)
                        .frame(width: 20, height: 20)
                    
                })
                // 버튼 씹힘 문제 해결
                .buttonStyle(.borderless)
                
                if !isEditing || isDeleting {
                    Text(work.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(work.isCompleted ? .gray : .black)
                        .onTapGesture {
                            isEditing = true
                        }
                    Spacer()
                } else {
                    TextField("", text: $content, onCommit: {
                        work.title = content
                        isEditing = false
                        isEditingDetail = false
                    })
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(work.isCompleted ? .gray : .black)
                    .onAppear {
                        content = work.title
                    }
                    Spacer()
                    Button(action: {
                        isEditingDetail = true
                    }, label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                    })
                    .buttonStyle(.borderless)
                }
            }
            .sheet(isPresented: $isEditingDetail) {
                EditWorkView(_work: work)
            }
            .onChange(of: work.title) {
                content = work.title
            }
            
            HStack {
                Text(work.dueDate, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(work.dueDate > Date.now ? .gray : .red)
                Spacer()
            }
            
        }
    }
}

#Preview {
    WorkRowView(work: Work(title: "축구", memo: "5대5 밀어내기",isCompleted: false))
        .environmentObject(Counts())
}


