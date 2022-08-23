//
//  BoreArView+Coaching.swift
//  ARDemo
//
//  Created by lcy on 2022/8/23.
//

import ARKit
import UIKit

extension BoreArView: ARCoachingOverlayViewDelegate {
    
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
        self.addSubview(coachingOverlay)
    }
    
}
