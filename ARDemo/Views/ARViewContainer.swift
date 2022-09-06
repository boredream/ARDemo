//
//  ARViewContainer.swift
//  ARDemo
//
//  Created by lcy on 2022/8/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var modelData: ModelData
    @Binding var editStatus: EditStatus
    @Binding var loaded: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = BoreArView(frame: .zero)
        arView.addCoaching()
        arView.setupGesture()
        arView.delegate = context.coordinator
        arView.modelData = modelData
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        print("DDD: updateUIView")
        
        guard let arView = uiView as? BoreArView else {
            return
        }
        
        if loaded {
            // 开始加载
            arView.loadWorldMap()
            DispatchQueue.main.async {
                loaded = false
            }
            return
        }
        
        // 遍历所有model
        var dataChanged = false
        for model in modelData.modelList {
            if model.action != .none {
                dataChanged = true
            }
            
            // 处理AR视图
            if model.action == .add {
                // 找到未添加的，加入AR
                if !model.hasAttachedInArView {
                    print("DDD: add model = \(model.name)")
                    arView.addModelEntity(model)
                }
            } else if model.action == .delete {
                // 删除
                if let modelEntity = model.modelEntity, let anchor = modelEntity.parent as? AnchorEntity {
                    // 先找到 entity，然后找到anchor，删除之
                    print("DDD: delete model = \(model.name)")
                    uiView.scene.removeAnchor(anchor)
                }
            } else if model.action == .update {
                // 更新
                if let modelEntity = model.modelEntity {
                    print("DDD: update model = \(model.name)")
                    modelEntity.update(model)
                }
            } else if model.action == .startMove {
                // 开始移动
                if let modelEntity = model.modelEntity {
                    print("DDD: start move model = \(model.name)")
                    uiView.installGestures([.rotation, .translation], for: modelEntity)
                }
            } else if model.action == .finishMove {
                // 结束移动
                print("DDD: finish move model = \(model.name)")
                // 过滤tap点击事件，其它的都删除
                uiView.gestureRecognizers?
                    .filter { return !($0 is UITapGestureRecognizer) }
                    .forEach(uiView.removeGestureRecognizer)
            }
            
            // 这里处理不会再次引起刷新？
            DispatchQueue.main.async {
                // 因为action是一次性的，用完后要重置状态
                if model.action == .add {
                    model.hasAttachedInArView = true
                } else if model.action == .delete {
                    modelData.selectModel = nil
                }
                model.action = .none
            }
        }
        
        // 如果有数据变更，保存数据
        if dataChanged {
            DispatchQueue.main.async {
                modelData.saveTolocal()
            }
        }
        
    }
    
    func makeCoordinator() -> ARViewCoordinator {
        return ARViewCoordinator(self)
    }

}
