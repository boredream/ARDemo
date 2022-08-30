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
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        // 平面探测
        config.planeDetection = [.horizontal]
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
            // .showAnchorOrigins, // 显示ARAnchor位置
            // .showAnchorGeometry, // 显示ARAnchor的几何形状
            // .showWorldOrigin, // 显示世界坐标系原点位置和坐标轴
            .showFeaturePoints // 显示特征点云
        ]
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addModelEntity(_ model: SignModel) {
        guard let modelEntity = model.modelEntity else {
            return
        }
        // MARK: - 不是非要在平面上添加锚点
        let anchorEntity = AnchorEntity(plane: .any)
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
