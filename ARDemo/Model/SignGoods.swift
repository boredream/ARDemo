//
//  SignGoods.swift
//  ARDemo
//
//  Created by lcy on 2022/9/13.
//

import Foundation

class SignGoods: Hashable {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: SignGoods, rhs: SignGoods) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

