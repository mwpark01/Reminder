//
//  RecentDeletedView.swift
//  Reminder
//
//  Created by mwpark on 2/1/25.
//

import SwiftUI

struct RecentDeletedView: View {
    @EnvironmentObject var counts: Counts
    
    var body: some View {
        HStack {
            Image(systemName: "trash.circle.fill")
                .resizable()
                .foregroundStyle(.gray)
                .frame(width: 30, height: 30)
            
            Text("최근 삭제된 항목")
                .foregroundStyle(.gray)
            Spacer()
            Text(String(counts.deletedWorkCount))
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    RecentDeletedView()
        .environmentObject(Counts())
}
