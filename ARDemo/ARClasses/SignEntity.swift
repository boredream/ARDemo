//
//  SignEntity.swift
//  ARDemo
//
//  Created by lcy on 2022/8/23.
//

import RealityKit
import SwiftUI

class SignEntity: Entity, HasModel, HasCollision {
    
    var selectCoverModelEntity: ModelEntity?
    
    init(colorName: String) {
        super.init()
        
        let mesh = MeshResource.generateSphere(radius: 0.05)
        let color = ColorUtil.getColorByName(colorName)
        let material = SimpleMaterial(color: SimpleMaterial.Color(color), isMetallic: false)
        self.model = ModelComponent(mesh: mesh, materials: [material])
        generateCollisionShapes(recursive: true)
        
        initSelectCover()
    }
    
    func initSelectCover() {
        // 选中样式
        let mesh = MeshResource.generateSphere(radius: 0.06)
        var material = SimpleMaterial()
        material.baseColor = MaterialColorParameter.color(
            .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3))
        selectCoverModelEntity = ModelEntity(mesh: mesh, materials: [material])
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
    
    func updateSelectState(_ selected: Bool) {
        if selected {
            // 选中
            addChild(selectCoverModelEntity!)
        } else {
            // 取消选中
            removeChild(selectCoverModelEntity!)
        }
    }
}
