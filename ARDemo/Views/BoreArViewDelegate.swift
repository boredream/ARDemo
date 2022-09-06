//
//  BoreArViewDelegate.swift
//  ARDemo
//
//  Created by lcy on 2022/8/24.
//

protocol BoreArViewDelegate {
    
    func onSignEntityTap(entity: SignEntity)
    
    func hasLocateWorldOrigin(located: Bool)
    
}
