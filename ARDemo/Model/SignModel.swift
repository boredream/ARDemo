//
//  SignModel.swift
//  ARDemo
//
//  Created by lcy on 2022/8/24.
//

import SwiftUI
import UIKit
import RealityKit

enum SignModelAction {
    case delete
    case add
    case update
    case startMove
    case cancelMove
    case confirmMove
    case none
}

class SignModel: NSObject, NSCoding {
    
    static func == (lhs: SignModel, rhs: SignModel) -> Bool {
        lhs.name == rhs.name
    }
    
    public override var hash: Int {
      var hasher = Hasher()
      hasher.combine(name)
      return hasher.finalize()
    }
    
    var name: String
    var colorName: String
    var goodsList: [SignGoods]

    var hasAttachedInArView: Bool
    var action: SignModelAction
    
    var modelEntity: SignEntity?
    var modelEntityTransform: float4x4?
    
    init(name: String, colorName: String, goodsList: [SignGoods] = []) {
        self.name = name
        self.colorName = colorName
        self.goodsList = goodsList
        
        self.hasAttachedInArView = false
        self.action = SignModelAction.none
        self.modelEntity = SignEntity(colorName: colorName)
    }
    
    convenience init(_ name: String) {
        self.init(name: name, colorName: "orange")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.colorName, forKey: "colorName")
        
        if let transform = modelEntityTransform {
            coder.encode(encodeFloat4(transform.columns.0), forKey: "transform0")
            coder.encode(encodeFloat4(transform.columns.1), forKey: "transform1")
            coder.encode(encodeFloat4(transform.columns.2), forKey: "transform2")
            coder.encode(encodeFloat4(transform.columns.3), forKey: "transform3")
        }
    }
    
    func encodeFloat4(_ float4: simd_float4) -> [Float] {
        return [float4.x, float4.y, float4.z, float4.w]
    }
    
    func decodeFloat4(_ float4: [Float]) -> simd_float4 {
        return SIMD4<Float>(float4[0], float4[1], float4[2], float4[3])
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: "name") as? String else { return nil }
        guard let colorName = coder.decodeObject(forKey: "colorName") as? String else { return nil }
        self.init(name: name, colorName: colorName)
        
        if let transform0 = coder.decodeObject(forKey: "transform0") as? [Float],
           let transform1 = coder.decodeObject(forKey: "transform1") as? [Float],
           let transform2 = coder.decodeObject(forKey: "transform2") as? [Float],
           let transform3 = coder.decodeObject(forKey: "transform3") as? [Float] {
            self.modelEntityTransform = simd_float4x4(decodeFloat4(transform0),
                                                      decodeFloat4(transform1),
                                                      decodeFloat4(transform2),
                                                      decodeFloat4(transform3))
        }
    }
}
