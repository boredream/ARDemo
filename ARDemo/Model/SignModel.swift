//
//  SignModel.swift
//  ARDemo
//
//  Created by lcy on 2022/8/24.
//

import SwiftUI
import UIKit

class SignModel: Hashable {
    
    static func == (lhs: SignModel, rhs: SignModel) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var name: String
    
    var modelEntity: SignEntity?
    
    init(_ name: String) {
        self.name = name
        self.modelEntity = SignEntity()
    }
    
}
