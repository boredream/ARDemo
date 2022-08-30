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
    
    func loadWorldMap() {
        guard let data = self.worldMapData else {
            fatalError("DDD: Map data should already be verified to exist before Load button is enabled.")
        }
        
        do {
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
                fatalError("DDD: No ARWorldMap in archive.")
            }
            
            let configuration = self.defaultConfiguration
            configuration.initialWorldMap = worldMap
            self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            print("DDD: success load world map \(worldMap)")
        } catch {
            fatalError("DDD: Can't unarchive ARWorldMap from file data: \(error)")
        }
    }
    
    func saveWorldMap() {
        self.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else {
                print("DDD: Can't get current world map")
                return
            }
            
            do {
                // 保存世界信息，以及所有自定义数据信息
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                self.storedData.set(data, forKey: self.mapKey)
                self.storedData.synchronize()
                print("DDD: success save world map \(map)")
            } catch {
                fatalError("DDD: Can't save map: \(error.localizedDescription)")
            }
        }
    }
    
}
