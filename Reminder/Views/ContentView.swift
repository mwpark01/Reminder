//
//  ContentView.swift
//  Reminder
//
//  Created by mwpark on 1/22/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var works: [Work]
    
    @EnvironmentObject var counts: Counts
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1)
                VStack {
                    Text("미리 알림")
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    HStack {
                        ButtonDesign(content: "오늘", color: .blue, imageString: "calendar.circle.fill", tag: 0)
                        ButtonDesign(content: "예정", color: .red, imageString: "calendar.circle.fill", tag: 1)
                    }
                    HStack {
                        ButtonDesign(content: "전체", color: .gray, imageString: "tray.circle.fill", tag: 2)
                        ButtonDesign(content: "완료됨", color: .gray, imageString: "checkmark.circle.fill", tag: 3)
                    }
                    
                    HStack {
                        Text("나의 목록")
                            .foregroundStyle(.black)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }
                    .onAppear {
                        let current = Calendar.current
                        counts.allCount = works.count
                        counts.completedWorkCount = 0
                        counts.expectedDayCount = 0
                        counts.todayCount = 0
                        
                        for work in works {
                            if work.isCompleted {
                                counts.completedWorkCount += 1
                            }
                            if current.isDateInToday(work.dueDate) {
                                counts.todayCount += 1
                            }
                            if work.dueDate > Date() {
                                counts.expectedDayCount += 1
                            } else {}
                        }
                    }
                    
                    VStack {
                        Button(action: {}, label: {
//                            NavigationLink(destination: DetailView(tag: 0)) {
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.gray)
                                    .frame(width: 30, height: 30)
                                
                                Text("삭제된 항목")
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("0")
                                    .foregroundStyle(.black)
//                            }
                        })
                        .padding()
                        .frame(width: 380, height: 50)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        
                    }
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
        
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Work.self, inMemory: true)
        .environmentObject(Counts())
}


