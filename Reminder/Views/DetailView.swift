//
//  DetailView.swift
//  Reminder
//
//  Created by mwpark on 1/22/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var works: [Work]
    @State private var isAdding: Bool = false
    @State private var isEditing: Bool = false
    @State private var tag: Int
    @State private var title: String
    @State private var titleColor: [Color] = [.blue, .red, .black, .gray]
    @State private var listColor: Color
    
    @EnvironmentObject var counts: Counts
    
    init(tag: Int, title: String = "", listColor: Color = .blue) {
        self.tag = tag
        self.listColor = listColor
        
        switch tag {
        case 0:
            self.title = "오늘"
        case 1:
            self.title = "예정"
        case 2:
            self.title = "전체"
        case 3:
            self.title = "완료됨"
        default:
            self.title = title
            
        }
        
        let predicate = #Predicate<Work> {
            $0.isDeleted == false
        }
        _works = Query(filter: predicate, sort: [SortDescriptor(\Work.dueDate)])
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(title)
                        .font(.largeTitle)
                        .foregroundStyle(tag < 4 ? titleColor[tag] : listColor)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                List {
                    ForEach(filtering(tag: tag)) { work in
                        WorkRowView(work: work)
                            .swipeActions(edge: .leading) {
                                NavigationLink(destination: EditWorkView(_work: work, editMode: 1)) {
                                    Text("Edit")
                                }
                                .tint(.yellow)
                            }
                    }
                    .onDelete(perform: deleteWorks)
                    .onTapGesture {
                        isEditing = true
                    }
                }
                Spacer()
                Button(action: {
                    isAdding = true
                }, label: {
                    Label("새로운 미리 알림", systemImage: "plus.circle.fill")
                        .font(.title2)
                })
            }
            .sheet(isPresented: $isAdding) {
                AddWorkView()
            }
        }
    }
    private func deleteWorks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                works[index].isDeleted = true
                works[index].deletedAt = Date()
            }
        }
    }
    private func filtering(tag: Int) -> [Work] {
        let filteredWorks = works.filter {
            switch tag {
            case 0:
                return Calendar.current.isDateInToday($0.dueDate) == true
            case 1:
                return $0.dueDate > Date()
            case 2:
                return true
            case 3:
                return $0.isCompleted == true
            default:
                return $0.myList == title
            }
        }
        return filteredWorks
    }
}
#Preview {
    DetailView(tag: 0)
        .environmentObject(Counts())
}
