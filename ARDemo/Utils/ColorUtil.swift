//
//  ColorUtil.swift
//  ARDemo
//
//  Created by lcy on 2022/8/25.
//

import UIKit
import SwiftUI

class ColorUtil {
    
    static func getColorByName(_ colorName: String) -> Color {
        let nameColorDict: [String: Color] = [
            "orange": .orange,
            "red": .red,
            "green": .green,
            "blue": .blue,
            "purple": .purple,
        ]
        print("DDD: getColorByName \(colorName)")
        return nameColorDict[colorName] ?? Color.orange
    }
    
}
