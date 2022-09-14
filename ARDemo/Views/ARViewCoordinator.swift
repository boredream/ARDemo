//
//  ARViewCoordinator.swift
//  ARDemo
//
//  Created by lcy on 2022/8/24.
//

import SwiftUI
import UIKit

// 这里负责处理需要从UIKit传递给SwiftUI的信息
class ARViewCoordinator: NSObject, BoreArViewDelegate {
    
    var container: ARViewContainer
    
    init(_ container: ARViewContainer) {
        self.container = container
    }
    
    func onSignEntityTap(entity: SignEntity) {
        if container.modelData.editStatus == .onMove {
            // 如果是移动中，则禁止选择其他model
            return
        }
        
        for model in container.modelData.modelList {
            if model.modelEntity === entity {
                // 找到被点击的Model
                container.modelData.selectModel = model
                container.modelData.editStatus = EditStatus.onModelSelect
                break;
            }
        }
    }
    
    func hasLocateWorldOrigin(located: Bool) {
        if located {
            container.modelData.editStatus = .ar
        }
    }
    
}
