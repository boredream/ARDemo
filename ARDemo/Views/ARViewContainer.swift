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
    
    @Binding var confirmModel: SignModel?
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
        if let model = self.confirmModel {
            if let modelEntity = model.modelEntity {
                print("DDD: adding model to scene \(model.name)")
                let anchorEntity = AnchorEntity(plane: .any)
                
                let appendModelEntity = modelEntity.clone(recursive: true)
                anchorEntity.addChild(appendModelEntity)
                
                uiView.installGestures(for: appendModelEntity)
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("DDD: unable load modelEntity \(model.name)")
            }
            
            // 因为是传入新增到AR中，一次性的，用完后清掉
            DispatchQueue.main.async {
                self.confirmModel = nil
            }
        }
    }
    
    func makeCoordinator() -> ARViewCoordinator {
        return ARViewCoordinator(self)
    }
}
