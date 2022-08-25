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
    
    @Binding var editStatus: EditStatus
    @Binding var allModel: [SignModel]
    @Binding var selectModel: SignModel?
    
    func makeUIView(context: Context) -> ARView {
        let arView = BoreArView(frame: .zero)
        arView.addCoaching()
        arView.addFocusEntity()
        arView.setupGesture()
        arView.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        print("DDD: updateUIView")
        
        // 遍历所有model
        for model in allModel {
            // 处理AR视图
            if model.action == .add {
                // 找到未添加的，加入AR
                if !model.hasAttachedInArView, let modelEntity = model.modelEntity {
                    print("DDD: add model = \(model.name)")
                    let anchorEntity = AnchorEntity(plane: .any)
                    anchorEntity.addChild(modelEntity)
                    uiView.scene.addAnchor(anchorEntity)
                }
            } else if model.action == .delete {
                // 删除
                if let modelEntity = model.modelEntity, let anchor = modelEntity.parent as? AnchorEntity {
                    // 先找到 entity，然后找到anchor，删除之
                    print("DDD: delete model = \(model.name)")
                    uiView.scene.removeAnchor(anchor)
                }
            } else if model.action == .startMove {
                if let modelEntity = model.modelEntity {
                    print("DDD: start move model = \(model.name)")
                    uiView.installGestures(for: modelEntity)
                }
            } else if model.action == .finishMove {
                if let modelEntity = model.modelEntity {
                    print("DDD: finish move model = \(model.name)")
                    // TODO: x
                    uiView.gest
                }
            }
            
            // 这里处理不会再次引起刷新？
            DispatchQueue.main.async {
                // 因为action是一次性的，用完后要重置状态
                if model.action == .add {
                    model.hasAttachedInArView = true
                } else if model.action == .delete {
                    selectModel = nil
                }
                model.action = .none
            }
        }
    }
    
    func makeCoordinator() -> ARViewCoordinator {
        return ARViewCoordinator(self)
    }
}
