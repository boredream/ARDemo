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
    @State private var selectSignEntity: SignEntity?
    
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
            ARViewContainer(confirmModel: $confirmModel, selectModel: $selectSignEntity)
            if self.isPlacementEnable {
                PlacementButtonView(
                    isPlacementEnable: $isPlacementEnable,
                    selectModel: $selectModel,
                    confirmModel: $confirmModel)
            } else {
                ModelPickerView(
                    isPlacementEnable: $isPlacementEnable,
                    selectModel: $selectModel,
                    models: models)
            }
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
