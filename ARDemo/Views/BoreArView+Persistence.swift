//
//  BoreArView+Persistence.swift
//  ARDemo
//
//  Created by lcy on 2022/8/29.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

extension BoreArView {
    
//    func loadWorldMap() {
//        guard let data = UserDefaults.standard.object(forKey: "ar.worldmap") as? Data else {
//            print("DDD: No World Map data in archive")
//            return
//        }
//
//        do {
//            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
//                fatalError("DDD: No ARWorldMap in archive.")
//            }
//
//            let configuration = self.defaultConfiguration
//            configuration.initialWorldMap = worldMap
//            self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//            print("DDD: success load world map \(worldMap)")
//        } catch {
//            fatalError("DDD: Can't unarchive ARWorldMap from file data: \(error)")
//        }
//    }
    
//    func saveWorldMap() {
//        // 每次保存数据，都要保存 ARWorld信息 + 自定义数据信息
//        self.session.getCurrentWorldMap { worldMap, error in
//            guard let map = worldMap else {
//                print("DDD: Can't get current world map")
//                return
//            }
//            
//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
//                UserDefaults.standard.set(data, forKey: "ar.worldmap")
//                UserDefaults.standard.synchronize()
//                print("DDD: success save world map \(map.anchors)")
//            } catch {
//                fatalError("DDD: Can't save map: \(error.localizedDescription)")
//            }
//        }
//    }
    
    func reloadAllModelEntity() {
        // 重新创建所有ModelEntity并添加
        guard let modelData = self.modelData else {
            return
        }
        
        for model in modelData.modelList {
            guard let modelEntity = model.modelEntity,
                  let transform = model.modelEntityTransform else {
                return
            }
            
            let anchorEntity = AnchorEntity(world: transform)
            anchorEntity.addChild(modelEntity)
            scene.addAnchor(anchorEntity)
            model.hasAttachedInArView = true
        }
        print("DDD: reloadAllModelEntity \(modelData.modelList.count)")
    }
    
}
