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
        
        // 遍历所有model
        var dataChanged = false
        for model in modelData.modelList {
            if model.action != .none {
                dataChanged = true
            }
            
            // 更新选中样式
            if let modelEntity = model.modelEntity {
                if let selectModel = modelData.selectModel {
                    modelEntity.updateSelectState(selectModel === model)
                } else {
                    modelEntity.updateSelectState(false)
                }
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
                    // TODO: 无需手动？
                    modelEntity.deletePinView()
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
                    // 记录之前位置
                    print("DDD: start move model = \(model.name)")
                    uiView.installGestures([.rotation, .translation], for: modelEntity)
                }
            } else if model.action == .cancelMove {
                // 取消移动
                print("DDD: cancel move model = \(model.name)")
                // 恢复到之前位置
                if let modelEntity = model.modelEntity,
                   let transform = model.modelEntityTransform{
                    modelEntity.move(to: transform, relativeTo: nil)
                }
                // 过滤tap点击事件，其它的都删除
                uiView.gestureRecognizers?
                    .filter { return $0 is EntityGestureRecognizer }
                    .forEach(uiView.removeGestureRecognizer)
                
            } else if model.action == .confirmMove {
                // 确定移动
                print("DDD: finish move model = \(model.name)")
                // 更新下位置
                if let modelEntity = model.modelEntity {
                    model.modelEntityTransform = modelEntity.transformMatrix(relativeTo: nil)
                }
                // 过滤tap点击事件，其它的都删除
                uiView.gestureRecognizers?
                    .filter { return $0 is EntityGestureRecognizer }
                    .forEach(uiView.removeGestureRecognizer)
            }
            
            // 这里处理不会再次引起刷新？
            DispatchQueue.main.async {
                // 因为action是一次性的，用完后要重置状态
                if model.action == .add {
                    model.hasAttachedInArView = true
                } else if model.action == .delete {
                    modelData.selectModel = nil
                    modelData.modelList.removeAll(where: { $0 === model })
                }
                model.action = .none
            }
        }
        
        // 如果有数据变更，保存
        if dataChanged {
            DispatchQueue.main.async {
                modelData.saveTolocal()
            }
        }
        
    }
    
    func makeCoordinator() -> ARViewCoordinator {
        return ARViewCoordinator(self)
    }

    // MARK: - Move
    var startMoveTransform: float4x4?
    
}
