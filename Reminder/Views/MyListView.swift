//
//  MyListView.swift
//  Reminder
//
//  Created by mwpark on 2/1/25.
//

import SwiftUI
import SwiftData

struct MyListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var works: [Work]
    @Query private var myLists: [MyList]
    
    init() {
        _myLists = Query(filter: nil, sort: [SortDescriptor(\MyList.createdAt)])
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    NavigationLink(destination: DeleteView()) {
                        RecentDeletedView()
                    }
                    ForEach(myLists) { myList in
                        
                        @State var filteringLists = works.filter {
                            $0.myList == myList.content
                        }
                        
                        NavigationLink(destination: DetailView(tag: 4, title: myList.content, listColor: myList.setColor)) {
                            HStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(myList.setColor)
                                    .overlay(content: {
                                        Image(systemName: myList.setSystemImages)
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(.white)
                                            .frame(width: 20, height: 20)
                                    })
                                Text(myList.content)
                                    .foregroundStyle(.black)
                                Spacer()
                                Text(String(filteringLists.count))
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .onDelete(perform: deleteWorks)
                }
                // 나의 목록 list 스타일 변경
                .scrollDisabled(true)
                .clipShape(.rect(cornerRadius: 10))
                .listStyle(.plain)
                .padding(EdgeInsets(top: 0,  leading: 10, bottom: 0,trailing: 10))
            }
        }
    }
    private func deleteWorks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                for work in works {
                    // 삭제하기 전에 목록 값을 초기화
                    if work.myList == myLists[index].content {
                        work.myList = ""
                    }
                }
                modelContext.delete(myLists[index])
            }
        }
    }
    
    
    
}
