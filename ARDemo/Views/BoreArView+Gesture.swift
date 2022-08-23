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
        let touchLocation = sender.location(in: self)
        print("touchLocation \(touchLocation)")
        
        var hitResult = hitTest(touchLocation)
        print("hit result \(hitResult)")
        
        guard let hitEntity = self.entity(at: touchLocation) else {
            return
        }
        
        print("hitEntity \(hitEntity)")
    }
    
}

