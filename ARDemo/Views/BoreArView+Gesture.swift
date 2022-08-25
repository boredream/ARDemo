//
//  BoreArView+Gesture.swift
//  ARDemo
//
//  Created by lcy on 2022/8/23.
//

import UIKit


extension BoreArView {

    func setupGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // 屏幕点击命中模型
        let touchLocation = sender.location(in: self)
        guard let hitEntity = self.entity(at: touchLocation) as? SignEntity else {
            return
        }

        delegate?.onSignEntityTap(entity: hitEntity)
        print("hitEntity \(hitEntity)")
    }

}

