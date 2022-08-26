//
//  SignEditView.swift
//  ARDemo
//
//  Created by lcy on 2022/8/25.
//

import SwiftUI

struct SignEditView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @Binding var showEditSheet: Bool
    @State var colorName: String = ""
    @State var name: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("关闭") {
                    showEditSheet = false
                }
                
                Spacer()
                
                Button("确定") {
                    // 去更新
                    modelData.selectModel?.name = self.name
                    modelData.selectModel?.colorName = self.colorName
                    modelData.selectModel?.action = .update
                    // TODO: 如何提醒modelList更新？
                    modelData.modelList += []
                    showEditSheet = false
                }
            }
            
            HStack {
                ForEach(modelData.colorNames, id: \.self) { key in
                    Button(action: {
                        colorName = key
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(ColorUtil.getColorByName(key))
                                .frame(width: 40, height: 40)
                            
                            Circle()
                                .stroke(colorName == key ? ColorUtil.getColorByName(key) : Color.white.opacity(0), lineWidth: 4)
                                .frame(width: 52, height: 52)
                        }
                    })
                }
            }
            
            HStack {
                Text("名称：").bold()
                Divider().frame(height: 20)
                TextField("name", text: $name)
            }
        }
        .padding(16)
        .onAppear(perform: {
            if let signModel = modelData.selectModel {
                self.colorName = signModel.colorName
                self.name = signModel.name
            }
        })
    }
}
