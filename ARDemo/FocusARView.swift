//
//  FocusARView.swift
//  ARDemo
//
//  Created by lcy on 2022/8/3.
//

import RealityKit
import FocusEntity
import Combine
import ARKit

class FocusARView: ARView {
    
    enum FocusStyleChoices {
        case classic
        case material
        case color
    }
    
    /// Style to be displayed in the example
    let focusStyle: FocusStyleChoices = .classic
    var focusEntity: FocusEntity?
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.setupConfig()
        
        switch self.focusStyle {
        case .color:
            self.focusEntity = FocusEntity(on: self, focus: .plane)
        case .material:
            do {
                let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
                let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
                self.focusEntity = FocusEntity(
                    on: self,
                    style: .colored(
                        onColor: onColor, offColor: offColor,
                        nonTrackingColor: offColor
                    )
                )
            } catch {
                self.focusEntity = FocusEntity(on: self, focus: .classic)
                print("DDD: Unable to load plane textures")
                print(error.localizedDescription)
            }
        default:
            self.focusEntity = FocusEntity(on: self, focus: .classic)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFocusEntity)))
    }
    
    @objc func tapFocusEntity() {
        print("DDD: tap focus entity")
        guard let focusEntity = self.focusEntity else {
            return
        }
        
        let anchor = AnchorEntity()
        self.scene.anchors.append(anchor)
        
        let mesh = MeshResource.generateBox(size: 0.1) // 单位米
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = focusEntity.position
        anchor.addChild(entity)
    }
    
    func setupConfig() {
        let config = ARWorldTrackingConfiguration()
        // 平面探测
        config.planeDetection = [.horizontal, .vertical]
        // 环境纹理
        config.environmentTexturing = .automatic
        // 判断设备是否支持配置
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            print("DDD: supportsSceneReconstruction")
            config.sceneReconstruction = .mesh
        }
        
        // 深度检测
        if type(of: config).supportsFrameSemantics(.sceneDepth) {
            print("DDD: supportsFrameSemantics")
            config.frameSemantics = .sceneDepth;
        }
        
        session.run(config)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FocusARView: FocusEntityDelegate {
    func toTrackingState() {
        print("DDD: tracking")
    }
    func toInitializingState() {
        print("DDD: initializing")
    }
}

