//
//  ModelData.swift
//  ARDemo
//
//  Created by lcy on 2022/8/26.
//

import Foundation

final class ModelData: ObservableObject {
    
    var colorNames = ["orange", "red", "green", "blue", "purple"]
    @Published var modelList: [SignModel] = []
    
}

