//
//  SignEntity.swift
//  ARDemo
//
//  Created by lcy on 2022/8/23.
//

import RealityKit
import SwiftUI
import RKPointPin

class SignEntity: Entity, HasModel, HasCollision, HasAnchoring {
    
    var selectCoverModelEntity: ModelEntity?
    var color: Color
    var arView: ARView?
    var pinView: RKPointPin?
    
    
    init(colorName: String) {
        self.color = ColorUtil.getColorByName(colorName)
        super.init()
        
        let mesh = MeshResource.generateSphere(radius: 0.05)
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
            color = ColorUtil.getColorByName(newModel.colorName)
            let material = SimpleMaterial(color: SimpleMaterial.Color(color), isMetallic: false)
            self.model = ModelComponent(mesh: model.mesh, materials: [material])
        }
    }
    
    func updateSelectState(_ selected: Bool) {
        if selected {
            // 选中
            addChild(selectCoverModelEntity!)
            
            appendPinView()
        } else {
            // 取消选中
            removeChild(selectCoverModelEntity!)
            
            deletePinView()
        }
    }
    
    // 新增Pin https://github.com/maxxfrazer/RKPointPin
    func appendPinView() {
        if let arView = arView {
            pinView = RKPointPin(color: SimpleMaterial.Color(color))
            pinView?.focusPercentage = 1
            arView.addSubview(pinView!)
            pinView?.targetEntity = self.parent // anchor entity
        }
    }
    
    // 移除 Pin
    func deletePinView() {
        if let pinView = pinView {
            pinView.removeFromSuperview()
            self.pinView = nil
        }
    }
}
