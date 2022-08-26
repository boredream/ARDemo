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
    case startMove
    case finishMove
    case none
}

class SignModel: Hashable {
    
    static func == (lhs: SignModel, rhs: SignModel) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var name: String
    var colorName: String
    var hasAttachedInArView: Bool
    var action: SignModelAction
    
    var modelEntity: SignEntity?
    
    init(_ name: String) {
        self.name = name
        self.colorName = "orange"
        self.hasAttachedInArView = false
        self.action = SignModelAction.none
        self.modelEntity = SignEntity(colorName: colorName)
    }
    
}
