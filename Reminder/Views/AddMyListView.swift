//
//  AddMyListView.swift
//  Reminder
//
//  Created by mwpark on 1/30/25.
//

import SwiftUI
import SwiftData

struct AddMyListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink, .gray]
    @State private var systemImages: [String] = ["face.smiling", "list.bullet", "bookmark.fill", "gift.fill", "birthday.cake.fill", "graduationcap.fill", "backpack.fill", "pencil.and.ruler.fill", "document.fill"]
    
    @State private var setSystemImages: String = "face.smiling"
    @State private var setColor: Color = .blue
    @State private var content: String = ""
    
    @Query private var works: [Work]
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
                        // Color 값을 String으로 바꿔야함.
                        let myList = MyList(content: content, setColor: "color", setSystemImages: setSystemImages)
                        modelContext.insert(myList)
                        dismiss()
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
    }
}
#Preview {
    AddMyListView()
}


