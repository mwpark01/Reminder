//
//  ReminderApp.swift
//  Reminder
//
//  Created by mwpark on 1/22/25.
//

import SwiftUI
import SwiftData

@main
struct ReminderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Work.self, // Work 모델
            MyList.self // MyList 모델
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(
                for: schema,  // 여러 모델을 전달
                configurations: modelConfiguration  // 각 모델에 대한 설정 리스트 전달
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)  // 모델 컨테이너 연결
        .environmentObject(Counts())
    }
}


