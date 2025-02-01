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
    // Work와 MyList 컨테이너
    var sharedModelContainer: ModelContainer = {
        let schema1 = Schema([Work.self])  // Work 모델
        let schema2 = Schema([MyList.self])  // MyList 모델

        // 각 모델에 대한 설정을 각각 따로 생성
        let modelConfiguration1 = ModelConfiguration(schema: schema1, isStoredInMemoryOnly: false)
        let modelConfiguration2 = ModelConfiguration(schema: schema2, isStoredInMemoryOnly: false)

        do {
            // 모델 컨테이너를 여러 모델과 각각의 설정으로 생성
            return try ModelContainer(
                for: Work.self, MyList.self,  // 여러 모델을 전달
                configurations: modelConfiguration1, modelConfiguration2  // 각 모델에 대한 설정 리스트 전달
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


