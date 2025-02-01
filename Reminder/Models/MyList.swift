//
//  MyList.swift
//  Reminder
//
//  Created by mwpark on 1/31/25.
//


import SwiftUI
import SwiftData

@Model
// Color는 UI 관련 타입이기 때문에, @Model로 사용되는 데이터 모델에서 저장할 수 있는 타입이어야 합니다.
// 그러나 Color는 기본적으로 Codable이나 Equatable을 따르지 않기 때문에 직접적으로 데이터를 저장하는 데 적합하지 않습니다.
final class MyList {
    var content: String
    var setColor: String
    var setSystemImages: String
    
    init(content: String = "", setColor: String = "blue", setSystemImages: String = "face.smiling") {
        self.content = content
        self.setColor = setColor
        self.setSystemImages = setSystemImages
    }
    
    // Color로 변환하는 computed property
    var color: Color {
        Color(setColor)
    }
}
