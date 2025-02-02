//
//  MyList.swift
//  Reminder
//
//  Created by mwpark on 1/31/25.
//


import SwiftUI
import SwiftData
import Foundation

@Model
// Color는 UI 관련 타입이기 때문에, @Model로 사용되는 데이터 모델에서 저장할 수 있는 타입이어야 합니다.
// 그러나 Color는 기본적으로 Codable이나 Equatable을 따르지 않기 때문에 직접적으로 데이터를 저장하는 데 적합하지 않습니다.
final class MyList {
    var content: String
    var setSystemImages: String
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    
    init(content: String = "", setSystemImages: String = "face.smiling",
         r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0) {
        self.content = content
        self.setSystemImages = setSystemImages
        self.r = r
        self.g = g
        self.b = b
    }
    
    var setColor : Color {
        Color(red: r, green: g, blue: b, opacity: 1.0)
    }
}
