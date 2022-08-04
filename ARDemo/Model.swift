//
//  Model.swift
//  ARDemo
//
//  Created by lcy on 2022/8/3.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName: String
    var modelEntitiy: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                // 处理失败
                print("DEBUG: unable to load modelEntity \(self.modelName)")
            }, receiveValue: { modelEntitiy in
                // 获取成功
                self.modelEntitiy = modelEntitiy
                print("DEBUG: successfully to load modelEntity \(self.modelName)")
            })
    }
    
}
