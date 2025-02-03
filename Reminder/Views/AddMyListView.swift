//
//  AddMyListView.swift
//  Reminder
//
//  Created by mwpark on 1/30/25.
//

import SwiftUI
import SwiftData
import Foundation

struct AddMyListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .gray]
    @State private var hexColors: [String] = [
        "#FC2125",  // red
        "#FD8206",  // orange
        "#FEC30B",  // yellow
        "#30C048",  // green
        "#0B5FFE",  // blue
        "#463BCD",  // indigo
        "#9D33D6",  // purple
        "#FF0066",  // pink
        "#808080"   // gray
    ]
    @State private var systemImages: [String] = ["face.smiling", "list.bullet", "bookmark.fill", "gift.fill", "birthday.cake.fill", "graduationcap.fill", "backpack.fill", "pencil.and.ruler.fill", "document.fill"]
    @State private var setSystemImages: String = "face.smiling"
    @State private var setColor: Color = .blue
    @State private var content: String = ""
    @State private var selectedIndex: Int = 4
    
    @Query private var myLists: [MyList]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Circle()
                            .foregroundColor(setColor)
                            .frame(width: 70, height: 70)
                            .overlay(content: {
                                Image(systemName: setSystemImages)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 35, height: 35)
                            })
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                    TextField("", text: $content, prompt:
                                Text("목록 이름").font(.title2).fontWeight(.bold))
                    .foregroundStyle(setColor)
                    .multilineTextAlignment(TextAlignment.center)
                    .padding(10)
                    .background(.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 10))
                    .onAppear {
                        // 지우는 버튼 추가
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
                }
                
                Section {
                    HStack {
                        ForEach(colors, id: \.self) { color in
                            Button(action: {
                                setColor = color
                                selectedIndex = colors.firstIndex(of: color)!
                            }, label: {
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                            })
                            .buttonStyle(.borderless)
                            .overlay(content: {
                                if(setColor == color) {
                                    Circle()
                                        .stroke(.gray, lineWidth: 2)
                                        .frame(width: 35, height: 35)
                                }
                            })
                        }
                    }
                }
                
                Section {
                    HStack {
                        ForEach(systemImages, id: \.self) { systemImage in
                            Button(action: {
                                setSystemImages = systemImage
                            }, label: {
                                Circle()
                                    .fill(.gray)
                                    .opacity(0.3)
                                    .frame(width: 30, height: 30)
                                    .overlay(content: {
                                        Image(systemName: systemImage)
                                            .resizable()
                                            .foregroundStyle(.gray)
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    })
                            })
                            .buttonStyle(.borderless)
                            .overlay(content: {
                                if(setSystemImages == systemImage) {
                                    Circle()
                                        .stroke(.gray, lineWidth: 2)
                                        .frame(width: 35, height: 35)
                                }
                            })
                        }
                    }
                }
            }
            .navigationTitle("새로운 목록")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        let rgb = hexStringToRGB(hex: hexColors[selectedIndex]) ?? (0, 0, 0)
                        let myList = MyList(content: content, setSystemImages: setSystemImages, r: rgb.r, g: rgb.g, b: rgb.b)
                        modelContext.insert(myList)
                        dismiss()
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
    }
    // HEX 색 문자열을 CGFloat으로 변환하는 함수
    func hexStringToRGB(hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat)? {
        // "#" 제거
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedHex = cleanedHex.replacingOccurrences(of: "#", with: "")
        
        // 유효한 6자리 또는 8자리 HEX 코드인지 확인
        guard cleanedHex.count == 6 else {
            print("잘못된 HEX 코드")
            return nil
        }
        
        // HEX 값을 정수형으로 변환
        if let hexNumber = Int(cleanedHex, radix: 16) {
            // 각 색상 (r, g, b)을 비트 연산으로 추출하고, 255로 나누어 0~1 사이로 변환
            let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(hexNumber & 0x0000FF) / 255.0
            
            return (r, g, b)
        }
        return nil
    }
}

#Preview {
    AddMyListView()
}


