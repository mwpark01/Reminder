//
//  MyListView.swift
//  Reminder
//
//  Created by mwpark on 2/1/25.
//

import SwiftUI
import SwiftData

struct MyListView: View {
    @Query private var myLists: [MyList]
    
    var body: some View {
        ForEach(myLists) { myList in
            Button(action: {}, label: {
                NavigationLink(destination: DetailView(tag: 4, title: myList.content, listColor: myList.setColor)) {
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
                }
            })
            .padding()
            .frame(width: 380, height: 50)
            .background(.white)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}
