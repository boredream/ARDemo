//
//  ContentView.swift
//  ARDemo
//
//  Created by lcy on 2022/7/29.
//

import SwiftUI
import RealityKit
import ARKit

enum EditStatus {
    case ready
    case ar
    case onModelSelect
    case onMove
}

struct ContentView : View {
    
    @EnvironmentObject var modelData: ModelData
    @State var showEditSheet = false
    @State var showSignListSheet = false
    
    var body: some View {
        ZStack {
            ARViewContainer()
            
            VStack {
                if modelData.editStatus == EditStatus.onModelSelect {
                    // 选中模型后，显示控制面板
                    HStack(spacing: 50) {
                        Button(action: {
                            modelData.selectModel = nil
                            modelData.editStatus = EditStatus.ar
                        }, label: {
                            Text("取消")
                        })
                        
                        Button(action: {
                            showEditSheet = true
                        }, label: {
                            Text("编辑")
                        })
                        .sheet(isPresented: $showEditSheet) {
                            SignModelDetailView(isEditMode: true, showEditSheet: $showEditSheet)
                        }
                        
                        Button(action: {
                            modelData.selectModel?.action = SignModelAction.startMove
                            modelData.editStatus = EditStatus.onMove
                        }, label: {
                            Text("移动")
                        })
                        
                        Button(action: {
                            modelData.selectModel?.action = SignModelAction.delete
                            modelData.editStatus = EditStatus.ar
                        }, label: {
                            Text("删除")
                        })
                    }
                    
                    Spacer()
                    
                    // 显示物品信息
                    if let model = modelData.selectModel {
                        VStack(alignment: .leading) {
                            HStack { }
                            Text("选中: \(model.name)")
                            ForEach(model.goodsList, id: \.self) { data in
                                Text(data.name)
                            }
                        }
                        .padding(16)
                        .background(Color.gray)
                    }
                } else if modelData.editStatus == EditStatus.onMove {
                    // 移动模式
                    HStack(spacing: 50) {
                        Button(action: {
                            // 取消移动后，恢复到选择模式
                            modelData.selectModel?.action = SignModelAction.cancelMove
                            modelData.editStatus = EditStatus.onModelSelect
                        }, label: {
                            Text("取消移动")
                        })
                        
                        Button(action: {
                            // 取消移动后，恢复到选择模式
                            modelData.selectModel?.action = SignModelAction.confirmMove
                            modelData.editStatus = EditStatus.onModelSelect
                        }, label: {
                            Text("确定移动")
                        })
                    }
                    
                    Spacer()
                    
                } else if modelData.editStatus == EditStatus.ar {
                    // ar 默认状态下，只显示添加按钮
                    Button("标记列表") {
                        showSignListSheet = true
                    }
                    .sheet(isPresented: $showSignListSheet) {
                        SignModelListView(showSheet: $showSignListSheet)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let model = SignModel("新增标记\(String(modelData.modelList.count))")
                        model.action = SignModelAction.add
                        modelData.modelList.append(model)
                    }, label: {
                        Text("添加")
                    })
                } else {
                    // 准备状态下，引导用户图片探测，以定位世界中心
                    // TODO: ready status 样式
                    Button(action: {
                        modelData.clearLocalData()
                    }, label: {
                        Text("清空数据")
                    })
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.gray.opacity(0.5))
    }
}
