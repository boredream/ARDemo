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

extension BoreArView: ARSessionDelegate {
    
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
        session.setWorldOrigin(relativeTransform: imageAnchor.transform)
        print("DDD: success detectedImage \(imageAnchor.transform)")
        
        detectedImage = true
    }

    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
}

