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
    
    @State private var isAddingWork: Bool = false
    @State private var isAddingList: Bool = false
    
    @State private var buttonContents: [String] = ["오늘", "예정", "전체", "완료됨"]
    @State private var buttonColors: [Color] = [.blue, .red, .gray, .gray]
    @State private var imageStrings: [String] = ["calendar.circle.fill", "calendar.circle.fill", "tray.circle.fill", "checkmark.circle.fill"]
    private var gridItems = [GridItem(.flexible()),
                             GridItem(.flexible())]
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
                    
                    LazyVGrid(columns: gridItems, spacing: 1) {
                        ForEach((0...3), id: \.self) { index in
                            ButtonDesign(content: buttonContents[index], color: buttonColors[index], imageString: imageStrings[index], tag: index)
                        }
                    }
                    
                    HStack {
                        Text("나의 목록")
                            .foregroundStyle(.black)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading)
                        Spacer()
                    }
                    
                    VStack {
                            MyListView()
                            RecentDeletedView()
                    }
                    Spacer()
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            isAddingWork = true
                        }, label: {
                            Label("새로운 미리 알림", systemImage: "plus.circle.fill")
                        })
                        .padding(.leading)
                        Spacer()
                        Button(action: {
                            isAddingList = true
                        }, label: {
                            Text("목록 추가")
                        })
                        .padding(.trailing)
                    }
                    .padding(.bottom)
                    .padding(.bottom)
                }
                .sheet(isPresented: $isAddingWork) {
                    AddWorkView()
                }
                .sheet(isPresented: $isAddingList) {
                    AddMyListView()
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Work.self, MyList.self], inMemory: true)
        .environmentObject(Counts())
}


