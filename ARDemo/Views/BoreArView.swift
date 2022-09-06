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
    // 已经按定位世界中心了（图片探测）
    var hasLocateWorldOrigin = false
    
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
        
        // 使用当前摄像头的位置+角度，在z-0.5 即镜头正前方放置物体（基于世界坐标）
        let cameraAnchorEntity = AnchorEntity(world: cameraTransform.matrix)
        let positionPlaceHolerEntity = Entity()
        positionPlaceHolerEntity.position.z -= 0.5
        cameraAnchorEntity.addChild(positionPlaceHolerEntity)
        scene.addAnchor(cameraAnchorEntity)
        
        // TODO: 是否有更好的方法？通过matrix直接修改去修改rotate？
        
        // 方向不希望随着camera，而是和世界保持一致
        // 所以用目标物体位置重新创建一个（relativeTo: nil获取世界位置，默认获取相对parent位置）
        let worldPositionPlaceHolerEntity = AnchorEntity(world: positionPlaceHolerEntity.position(relativeTo: nil))
        scene.addAnchor(worldPositionPlaceHolerEntity)
        
        // 然后创建个ARKit的anchor，以此为基准添加entity
        let transform = worldPositionPlaceHolerEntity.transform.matrix
        let anchor = ARAnchor(name: model.name, transform: transform)
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(modelEntity)
        scene.addAnchor(anchorEntity)
        
        // 最后删除辅助entity
        scene.removeAnchor(cameraAnchorEntity)
        scene.removeAnchor(worldPositionPlaceHolerEntity)
    }
    
    // 在锚点重载对象
    func reloadModelEntityAtAnchor(anchor: ARAnchor) {
        // TODO: 首先要判断是否已经添加过了，普通add也会触发该回调 ?
        print("DDD: reloadModelEntityAtAnchor \(anchor)")
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
    
}
