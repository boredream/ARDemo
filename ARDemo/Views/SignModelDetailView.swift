//
//  SignGoodsListView.swift
//  ARDemo
//
//  Created by lcy on 2022/9/13.
//

import SwiftUI

struct SignModelDetailView: View {
    @EnvironmentObject var modelData: ModelData
    
    // 是否是编辑模式
    @State var isEditMode: Bool
    
    // 编辑模式是弹出方式，本字段是控制弹出对话框展示情况
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
                    modelData.selectModel?.goodsList = modelData.goodsList
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
                Text("标记名称：").bold()
                Divider().frame(height: 20)
                TextField("请输入标记名称", text: $name)
            }
            
            Spacer().frame(height: 32)
            
            Text("物品清单")

            // TODO: 会引起一直update view ？
            ForEach($modelData.goodsList, id: \.self) { data in
                HStack {
                    TextField("请输入物品名称", text: data.name)
                    Button("删除") {
                        if let index = modelData.goodsList.firstIndex(of: data.wrappedValue) {
                            modelData.goodsList.remove(at: index)
                        }
                    }
                }.padding(8)
            }
        }
        .padding(16)
        .onAppear(perform: {
            if let signModel = modelData.selectModel {
                self.colorName = signModel.colorName
                self.name = signModel.name
                self.modelData.goodsList = signModel.goodsList
            }
        })
    }
}
