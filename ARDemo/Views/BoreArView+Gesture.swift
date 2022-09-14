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
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // 屏幕点击命中模型
        let touchLocation = sender.location(in: self)
        guard let hitEntity = self.entity(at: touchLocation) as? SignEntity else {
            return
        }

        delegate?.onSignEntityTap(entity: hitEntity)
        // print("hitEntity \(hitEntity)")
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state != .changed {
            // changed为实际拖动回调，其它状态下都清空last位置信息
            self.lastPanPoint = nil
            return
        }
        
        guard let modelData = self.modelData,
              let selectModel = modelData.selectModel,
              let modelEntity = selectModel.modelEntity
        else { return }
        
        if modelData.editStatus != .onMove {
            return
        }
        
        // 拖拽，只在选中移动模式生效，用于y轴移动
        // 优先级低于installGesture，即touch down的时候未点击到model才会生效
        let new = sender.translation(in: self)
        if let last = self.lastPanPoint {
            // 上一次有值，计算差值，进行移动
            var dif = last.y - new.y
            // gesture的坐标单位是像素密度，而ar里position单位是米，所以要进行转换
            dif /= 500
            modelEntity.position.y += Float(dif)
            // print("DDD: trans \(modelEntity.position)")
        }
        self.lastPanPoint = new
        
    }

}

