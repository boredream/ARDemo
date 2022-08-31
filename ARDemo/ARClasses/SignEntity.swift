//
//  SignEntity.swift
//  ARDemo
//
//  Created by lcy on 2022/8/23.
//

import RealityKit
import SwiftUI

class SignEntity: Entity, HasModel, HasCollision {
    
    init(colorName: String) {
        super.init()
        
//        let mesh = MeshResource.generateBox(size: [0.01, 0.01, 0.01])
        let mesh = MeshResource.generateText("考拉在此！",
                                             extrusionDepth: 0.001,
                                             font: .init(name: "Helvetica", size: 0.02)!)
        let color = ColorUtil.getColorByName(colorName)
        let material = SimpleMaterial(color: SimpleMaterial.Color(color), isMetallic: false)
        self.model = ModelComponent(mesh: mesh, materials: [material])
        generateCollisionShapes(recursive: true)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func update(_ newModel: SignModel) {
        if let model = self.model {
            let color = ColorUtil.getColorByName(newModel.colorName)
            let material = SimpleMaterial(color: SimpleMaterial.Color(color), isMetallic: false)
            self.model = ModelComponent(mesh: model.mesh, materials: [material])
        }
    }
}
