//
//  BoreArView+Session.swift
//  ARDemo
//
//  Created by lcy on 2022/8/30.
//

import Foundation

import Foundation
import RealityKit
import ARKit
import SwiftUI

extension BoreArView: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // 计算镜头到物体的距离
        if let modelData = modelData,
           let model = modelData.selectModel,
           let entity = model.modelEntity {
            
            let cameraEntity = AnchorEntity(world: frame.camera.transform)
            scene.addAnchor(cameraEntity)
            let distance = calculateDistance(from: cameraEntity, to: entity)
            print("session \(distance)")
            scene.removeAnchor(cameraEntity)
        }
    }
    
    func calculateDistance(from: Entity, to: Entity) -> Float{
        let fromPosition = from.position(relativeTo: nil)
        let toPosition = to.position(relativeTo: nil)
        // print("from position = \(fromPosition)")
        // print("to position = \(toPosition)")
        return sqrtf(
            powf(fromPosition.x - toPosition.x, 2) +
            powf(fromPosition.y - toPosition.y, 2) +
            powf(fromPosition.z - toPosition.z, 2))
    }
    
    // This is where we render virtual contents to scene.
    // We add an anchor in `handleTap` function, it will then call this function.
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("session didAdd anchors count = \(anchors.count)")
        for anchor in anchors {
            reloadModelEntityAtAnchor(anchor: anchor)
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let imageAnchor = anchors.first as? ARImageAnchor,
              let _ = imageAnchor.referenceImage.name
        else { return }
        
        if detectedImage {
            return
        }
        
        // 重新设置WorldOrigin
        // TODO - 保持y纵向
        session.setWorldOrigin(relativeTransform: imageAnchor.transform)
        print("DDD: success detectedImage \(imageAnchor.transform)")
        
        detectedImage = true
    }

    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
}

