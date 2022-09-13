//
//  SignGoods.swift
//  ARDemo
//
//  Created by lcy on 2022/9/13.
//

import Foundation

class SignGoods: Hashable {
    
    var id = UUID()
    var name: String
    var isDelete: Bool
    
    init(name: String) {
        self.name = name
        self.isDelete = false
    }
    
    static func == (lhs: SignGoods, rhs: SignGoods) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

