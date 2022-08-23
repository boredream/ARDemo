//
//  SignEntity.swift
//  ARDemo
//
//  Created by lcy on 2022/8/23.
//

import RealityKit

class SignEntity: Entity, HasModel, HasCollision {
    
    required init() {
        super.init()
        let mesh = MeshResource.generateBox(size: [0.1, 0.1, 0.1])
        let material = SimpleMaterial(color: .red, isMetallic: false)
        self.model = ModelComponent(mesh: mesh, materials: [material])
//        self.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: [0.1, 0.1, 0.1])])
    }
    
}
