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
    @State var selectModel: SignModel?
    
    var body: some View {
        NavigationView {
            ZStack {
                ARViewContainer(editStatus: $editStatus, selectModel: $selectModel)
                
                VStack {
                    if editStatus == EditStatus.onModelSelect {
                        // 选中模型后，显示控制面板
                        HStack(spacing: 50) {
                            Button(action: {
                                selectModel = nil
                                editStatus = EditStatus.ar
                            }, label: {
                                Text("取消")
                            })
                            
                            if let model = selectModel {
                                NavigationLink(destination: SignEditView(signModel: model), label: {
                                    Text("编辑")
                                })
                            }
                            
                            Button(action: {
                                if let model = selectModel {
                                    model.action = SignModelAction.startMove
                                    editStatus = EditStatus.onMove
                                }
                            }, label: {
                                Text("移动")
                            })
                            
                            Button(action: {
                                if let model = selectModel {
                                    model.action = SignModelAction.delete
                                    editStatus = EditStatus.ar
                                }
                            }, label: {
                                Text("删除")
                            })
                        }
                        
                        Spacer()
                        
                        if let model = self.selectModel {
                            VStack(alignment: .leading) {
                                Text("选中: \(model.name)")
                            }
                            .background(Color.gray)
                        }
                    } else if editStatus == EditStatus.onMove {
                        // 移动模式
                        HStack(spacing: 50) {
                            Button(action: {
                                // 取消移动后，恢复到选择模式
                                if let model = self.selectModel {
                                    model.action = SignModelAction.finishMove
                                    editStatus = EditStatus.onModelSelect
                                }
                            }, label: {
                                Text("取消")
                            })
                        }
                        
                        Spacer()
                        
                    } else {
                        // 默认状态下，只显示添加按钮
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
        .navigationTitle("返回")
    }
}
