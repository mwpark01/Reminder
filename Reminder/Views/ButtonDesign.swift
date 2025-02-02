//
//  ButtonDesign.swift
//  Reminder
//
//  Created by mwpark on 1/28/25.
//

import SwiftUI
import SwiftData

struct ButtonDesign: View {
    @State private var content: String
    @State private var color: Color
    @State private var imageString: String
    @State private var tag: Int
    
    @EnvironmentObject var counts: Counts
    @Query private var works: [Work]
    
    init(content: String, color: Color, imageString: String, tag: Int) {
        self.content = content
        self.color = color
        self.imageString = imageString
        self.tag = tag
    }
    
    var body: some View {
        Button(action: {
        }, label: {
            NavigationLink(destination: DetailView(tag: tag)) {
                VStack {
                    HStack {
                        Image(systemName: imageString)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(color)
                        Spacer()
                        VStack {
                            if tag == 0 {
                                Text(String(counts.todayCount))
                            } else if tag == 1 {
                                Text(String(counts.expectedDayCount))
                            } else if tag == 2 {
                                Text(String(counts.allCount))
                            } else if tag == 3 {
                                Text(String(counts.completedWorkCount))
                            }
                        }
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    }
                    HStack {
                        Text(content)
                            .foregroundStyle(.gray)
                            .font(.title2)
                        Spacer()
                    }
                }
                .padding()
                .frame(width: 190, height: 100)
                .background(.white)
                .clipShape(.rect(cornerRadius: 10))
            }
        })
        .padding(.bottom)
        .onAppear{
            reloadData()
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

#Preview {
    ButtonDesign(content: "오늘", color: .blue, imageString: "calendar.circle.fill", tag: 0)
        .environmentObject(Counts())
}
