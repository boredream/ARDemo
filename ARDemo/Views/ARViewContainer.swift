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
    
    @Binding var allModel: [SignModel]
    var selectModel: SignEntity?
    
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
        for model in allModel {
            // 遍历所有model，找到未添加的，加入AR
            if !model.hasAttachedInArView, let modelEntity = model.modelEntity {
                print("DDD: adding model to scene \(model.name)")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
            }
            
            // 因为是传入新增到AR中，一次性的，用完后清掉
            DispatchQueue.main.async {
                model.hasAttachedInArView = true
            }
        }
    }
    
    func makeCoordinator() -> ARViewCoordinator {
        return ARViewCoordinator(self)
    }
}
