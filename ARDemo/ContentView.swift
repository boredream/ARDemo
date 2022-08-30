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
    case ar
    case onModelSelect
    case onMove
}

struct ContentView : View {
    
    @EnvironmentObject var modelData: ModelData
    @State var editStatus = EditStatus.ar
    @State var showEditSheet = false
    @State var saved = false
    @State var loaded = false
    
    var body: some View {
        ZStack {
            ARViewContainer(editStatus: $editStatus, saved: $saved, loaded: $loaded)
            
            VStack {
                if editStatus == EditStatus.onModelSelect {
                    // 选中模型后，显示控制面板
                    HStack(spacing: 50) {
                        Button(action: {
                            modelData.selectModel = nil
                            editStatus = EditStatus.ar
                        }, label: {
                            Text("取消")
                        })
                        
                        Button(action: {
                            showEditSheet = true
                        }, label: {
                            Text("编辑")
                        })
                        .sheet(isPresented: $showEditSheet) {
                            SignEditView(showEditSheet: $showEditSheet)
                        }
                        
                        Button(action: {
                            modelData.selectModel?.action = SignModelAction.startMove
                            editStatus = EditStatus.onMove
                        }, label: {
                            Text("移动")
                        })
                        
                        Button(action: {
                            modelData.selectModel?.action = SignModelAction.delete
                            editStatus = EditStatus.ar
                        }, label: {
                            Text("删除")
                        })
                    }
                    
                    Spacer()
                    
                    if let model = modelData.selectModel {
                        VStack(alignment: .leading) {
                            Text("选中: \(model.name)")
                        }
                        .padding(16)
                        .background(Color.gray)
                    }
                } else if editStatus == EditStatus.onMove {
                    // 移动模式
                    HStack(spacing: 50) {
                        Button(action: {
                            // 取消移动后，恢复到选择模式
                            modelData.selectModel?.action = SignModelAction.finishMove
                            editStatus = EditStatus.onModelSelect
                        }, label: {
                            Text("取消")
                        })
                    }
                    
                    Spacer()
                    
                } else {
                    // 默认状态下，只显示添加按钮
                    HStack(spacing: 50) {
                        Button(action: {
                            saved = true
                        }, label: {
                            Text("保存")
                        })
                        
                        Button(action: {
                            loaded = true
                        }, label: {
                            Text("加载")
                        })
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let model = SignModel("新增标记\(String(modelData.modelList.count))")
                        model.action = SignModelAction.add
                        modelData.modelList.append(model)
                    }, label: {
                        Text("添加")
                    })
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.gray.opacity(0.5))
    }
}
