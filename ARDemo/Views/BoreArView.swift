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
    
    var delegate: BoreArViewDelegate?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        setupConfig()
        
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
    
    func setupConfig() {
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
        
        session.run(config)
    }
    
}
