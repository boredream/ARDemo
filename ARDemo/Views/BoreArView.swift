//
//  BDArView.swift
//  ARDemo
//
//  Created by lcy on 2022/8/23.
//


import RealityKit
import FocusEntity
import Combine
import ARKit

class BoreArView: ARView {
    
    var modelData: ModelData?
    var delegate: BoreArViewDelegate?
    var detectedImage = false
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let config = ARWorldTrackingConfiguration()
        config.detectionImages = referenceImages
        config.maximumNumberOfTrackedImages = 1
        return config
    }
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        self.session.delegate = self
        self.session.run(defaultConfiguration)
        
        // debug模式显示AR识别信息
        debugOptions = [
            // .showPhysics, // 绘制碰撞器（包围盒）和所有刚体
            // .showStatistics, // 显示性能统计信息
//             .showAnchorOrigins, // 显示ARAnchor位置
            // .showAnchorGeometry, // 显示ARAnchor的几何形状
             .showWorldOrigin, // 显示世界坐标系原点位置和坐标轴
//            .showFeaturePoints // 显示特征点云
        ]
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func addModelEntity(_ model: SignModel) {
//        guard let modelEntity = model.modelEntity else {
//            return
//        }
//        // MARK: - 不是非要在平面上添加锚点
//        let anchorEntity = AnchorEntity(plane: .any)
//        anchorEntity.addChild(modelEntity)
//        scene.addAnchor(anchorEntity)
//    }
    
    func addModelEntity(_ model: SignModel) {
        guard let modelEntity = model.modelEntity else {
            return
        }
        let anchorEntity = AnchorEntity(world: cameraTransform.matrix)
        modelEntity.position.z -= 0.5
        anchorEntity.addChild(modelEntity)
        scene.addAnchor(anchorEntity)
    }
    
    // 在锚点重载对象
    func reloadModelEntityAtAnchor(anchor: ARAnchor) {
        // 首先要判断是否已经添加过了，普通add也会触发该回调 ?
        guard let modelAnchor = anchor as? ARPlaneAnchor else {
            // 筛选类型
            return
        }
        
        print("reloadModelEntityAtAnchor \(modelAnchor)")
        
        guard let modelData = self.modelData else {
            return
        }
        
        // MARK: - 如何把model和anchor匹配？
        for model in modelData.modelList {
            if model.name == modelAnchor.name {
                print("match model \(model)")
                break
            }
        }
    }
    
    // MARK: - Persistence: Saving and Loading
    let storedData = UserDefaults.standard
    let mapKey = "ar.worldmap"

    lazy var worldMapData: Data? = {
        storedData.data(forKey: mapKey)
    }()
    
    func resetTracking() {
        self.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}
