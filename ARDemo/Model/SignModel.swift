//
//  SignModel.swift
//  ARDemo
//
//  Created by lcy on 2022/8/24.
//

import SwiftUI
import UIKit

enum SignModelAction {
    case delete
    case add
    case update
    case startMove
    case finishMove
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
    var hasAttachedInArView: Bool
    var action: SignModelAction
    
    var modelEntity: SignEntity?
    
    init(name: String, colorName: String) {
        self.name = name
        self.colorName = colorName
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
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: "name") as? String else { return nil }
        guard let colorName = coder.decodeObject(forKey: "colorName") as? String else { return nil }
        self.init(name: name, colorName: colorName)
    }
    
}
