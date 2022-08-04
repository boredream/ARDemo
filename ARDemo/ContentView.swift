//
//  ContentView.swift
//  ARDemo
//
//  Created by lcy on 2022/7/29.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    @State private var isPlacementEnable = false
    @State private var selectModel: Model?
    @State private var confirmModel: Model?
    
    private var models: [Model] = {
        let filenamager = FileManager.default
       
        guard let path = Bundle.main.resourcePath,
              let files = try? filenamager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var avalableModels: [Model] = []
        for filename in files where filename.hasSuffix(".usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName)
            avalableModels.append(model)
        }
        return avalableModels
    }()
      
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(confirmModel: self.$confirmModel)
            if self.isPlacementEnable {
                PlacementButtonView(
                    isPlacementEnable: self.$isPlacementEnable,
                    selectModel: self.$selectModel,
                    confirmModel: self.$confirmModel)
            } else {
                ModelPickerView(
                    isPlacementEnable: self.$isPlacementEnable,
                    selectModel: self.$selectModel,
                    models: self.models)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var confirmModel: Model?
    
    func makeUIView(context: Context) -> ARView {
        let arView = FocusARView(frame: .zero)
        arView.addCoaching()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.confirmModel {
            if let modelEntity = model.modelEntitiy {
                print("DEBUG: adding model to scene \(model.modelName)")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("DEBUG: unable load modelEntity \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                self.confirmModel = nil
            }
        }
    }
}

extension FocusARView: ARCoachingOverlayViewDelegate{
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        self.placeBox()
    }
    
    @objc func placeBox(){
        let boxMesh = MeshResource.generateBox(size: 0.15)
        var boxMaterial = SimpleMaterial(color:.white,isMetallic: false)
        let planeAnchor = AnchorEntity(plane:.horizontal)
        do {
            boxMaterial.baseColor = try .texture(.load(named: "Box_Texture.jpg"))
            boxMaterial.tintColor = UIColor.white.withAlphaComponent(0.9999)
            let boxEntity  = ModelEntity(mesh:boxMesh,materials:[boxMaterial])
            planeAnchor.addChild(boxEntity)
            self.scene.addAnchor(planeAnchor)
        } catch {
            print("找不到文件")
        }
    }
}

struct ModelPickerView: View {
    @Binding var isPlacementEnable: Bool
    @Binding var selectModel: Model?
    
    var models: [Model]
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(0 ..< self.models.count) { index in
                    Button(action: {
                        self.isPlacementEnable = true
                        self.selectModel = self.models[index]
                    }, label: {
                        Image(self.models[index].modelName)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .background(Color.white)
                            .cornerRadius(12)
                    })
                }
            }
        } .padding(20).background(Color.black.opacity(0.5))
    }
}

struct PlacementButtonView: View {
    @Binding var isPlacementEnable: Bool
    @Binding var selectModel: Model?
    @Binding var confirmModel: Model?
    
    var body: some View {
        HStack {
            Button(action: {
                self.isPlacementEnable = false
                self.selectModel = nil
            }, label: {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            })
            
            Button(action: {
                self.isPlacementEnable = false
                self.confirmModel = self.selectModel
                self.selectModel = nil
            }, label: {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            })
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif