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
    
    @State var editStatus = EditStatus.ar
    @State var selecModel: SignModel?
    @State var allModel: [SignModel] = []
    
    var body: some View {
        ZStack {
            ARViewContainer(allModel: $allModel)
            
            VStack {
                if editStatus == EditStatus.onModelSelect {
                    // 选中模型后，显示控制面板
                    HStack(spacing: 50) {
                        Button(action: {
                            selecModel = nil
                            editStatus = EditStatus.ar
                        }, label: {
                            Text("取消")
                        })
                        
                        Button(action: {
                            print("edit")
                        }, label: {
                            Text("编辑")
                        })
                        
                        Button(action: {
                            print("move")
                        }, label: {
                            Text("移动")
                        })
                        
                        Button(action: {
                            print("remove")
//                            if let model = selecModel, let index = allModel.firstIndex(of: model) {
//                                allModel.remove(at: index)
//                                selecModel = nil
//                                editStatus = EditStatus.ar
//                            }
                        }, label: {
                            Text("删除")
                        })
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("选中: \(self.selecModel!.name)")
                            .frame(width: .infinity)
                    }
                    .background(Color.gray)
                } else if editStatus == EditStatus.onMove {
                    // 移动模式
                    
                } else {
                    // 默认状态下，只显示添加按钮
                    Spacer()
                    
                    Button(action: {
                        print("DDD: add")
                        allModel.append(SignModel("新增标记"))
                    }, label: {
                        Text("添加")
                    })
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
