//
//  SignEditView.swift
//  ARDemo
//
//  Created by lcy on 2022/8/25.
//

import SwiftUI

struct SignEditView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var signModel: SignModel
    @Binding var showEditSheet: Bool
    @State var colorName: String
    @State var name: String
    
    init(signModel: SignModel, showEditSheet: Binding<Bool>) {
        self.signModel = signModel
        self._showEditSheet = showEditSheet
        self.colorName = signModel.colorName
        self.name = signModel.name
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("关闭") {
                    self.showEditSheet = false
                }
                
                Spacer()
                
                Button("确定") {
                    // 去更新
                    self.signModel.name = self.name
                    self.signModel.colorName = self.colorName
                    self.showEditSheet = false
                }
            }
            
            HStack {
                ForEach(modelData.colorNames, id: \.self) { key in
                    Button(action: {
                        colorName = key
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(ColorUtil.getColorByName(key))
                                .frame(width: 40, height: 40)
                            
                            Circle()
                                .stroke(colorName == key ? ColorUtil.getColorByName(key) : Color.white.opacity(0), lineWidth: 4)
                                .frame(width: 52, height: 52)
                        }
                    })
                }
            }
            
            HStack {
                Text("名称：").bold()
                Divider().frame(height: 20)
                TextField("name", text: $name)
            }
        }
        .padding(16)
    }
}

struct SignEdit_Previews: PreviewProvider {
    static var previews: some View {
        SignEditView(signModel: SignModel("name"), showEditSheet: .constant(true))
    }
}
