//
//  FocusARView.swift
//  ARDemo
//
//  Created by lcy on 2022/8/3.
//

import RealityKit
import FocusEntity
import Combine
import ARKit

class FocusARView: ARView {
    
  enum FocusStyleChoices {
    case classic
    case material
    case color
  }

  /// Style to be displayed in the example
  let focusStyle: FocusStyleChoices = .classic
  var focusEntity: FocusEntity?
  required init(frame frameRect: CGRect) {
    super.init(frame: frameRect)
    self.setupConfig()

    switch self.focusStyle {
    case .color:
      self.focusEntity = FocusEntity(on: self, focus: .plane)
    case .material:
      do {
        let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
        let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
        self.focusEntity = FocusEntity(
          on: self,
          style: .colored(
            onColor: onColor, offColor: offColor,
            nonTrackingColor: offColor
          )
        )
      } catch {
        self.focusEntity = FocusEntity(on: self, focus: .classic)
        print("Unable to load plane textures")
        print(error.localizedDescription)
      }
    default:
      self.focusEntity = FocusEntity(on: self, focus: .classic)
    }
  }

  func setupConfig() {
      let config = ARWorldTrackingConfiguration()
      // 平面探测
      config.planeDetection = [.horizontal, .vertical]
      // 环境纹理
      config.environmentTexturing = .automatic
      // 判断设备是否支持配置
      if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
          config.sceneReconstruction = .mesh
      }
      
      #if DEBUG
      // debug模式显示AR识别信息
      self.debugOptions = [
//        .showPhysics, // 绘制碰撞器（包围盒）和所有刚体
//        .showStatistics, // 显示性能统计信息
//        .showAnchorOrigins, // 显示ARAnchor位置
//        .showAnchorGeometry, // 显示ARAnchor的几何形状
        .showWorldOrigin, // 显示世界坐标系原点位置和坐标轴
//        .showFeaturePoints // 显示特征点云
      ]
      session.run(config)
      #endif
  }

  @objc required dynamic init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FocusARView: FocusEntityDelegate {
  func toTrackingState() {
    print("tracking")
  }
  func toInitializingState() {
    print("initializing")
  }
}

