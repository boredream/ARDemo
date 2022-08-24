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
        container.selectModel = entity
    }
    
}
