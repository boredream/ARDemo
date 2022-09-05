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
            
            let position = SIMD3(frame.camera.transform.columns.3.x,
                                 frame.camera.transform.columns.3.y,
                                 frame.camera.transform.columns.3.z)
            let distance = calculateDistance(from: position, to: entity.position(relativeTo: nil))
            print("session \(distance)")
        }
    }
    
    func calculateDistance(from: SIMD3<Float>, to: SIMD3<Float>) -> Float{
        return sqrtf(
            powf(from.x - to.x, 2) +
            powf(from.y - to.y, 2) +
            powf(from.z - to.z, 2))
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

