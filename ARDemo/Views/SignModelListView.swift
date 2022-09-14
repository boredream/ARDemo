//
//  SignModelListView.swift
//  ARDemo
//
//  Created by lcy on 2022/9/14.
//

import SwiftUI

struct SignModelListView: View {
    @EnvironmentObject var modelData: ModelData
    
    // 编辑模式是弹出方式，本字段是控制弹出对话框展示情况
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("标记清单")
                
                Button("关闭") {
                    showSheet = false
                }
            }
            
            ForEach(modelData.modelList, id: \.self) { model in
                HStack {
                    Circle()
                        .fill(ColorUtil.getColorByName(model.colorName))
                        .frame(width: 20, height: 20)
                    Text(model.name)
                    Button("选中") {
                        modelData.selectModel = model
                        modelData.editStatus = EditStatus.onModelSelect
                    }
                }.padding(8)
            }
        }
        .padding(16)
    }
}
