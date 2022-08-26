//
//  SignEditView.swift
//  ARDemo
//
//  Created by lcy on 2022/8/25.
//

import SwiftUI

struct SignEditView: View {
    
    var colorNames = ["orange", "red", "green", "blue", "purple"]
    
    @State var signModel: SignModel
    
    var body: some View {
        VStack {
            HStack {
                ForEach(colorNames, id: \.self) { key in
                    Button(action: {
                        self.signModel.colorName = key
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(ColorUtil.getColorByName(key))
                                .frame(width: 40, height: 40)
                            
                            Circle()
                                .stroke(signModel.colorName == key ? ColorUtil.getColorByName(key) : Color.white.opacity(0), lineWidth: 4)
                                .frame(width: 52, height: 52)
                        }
                    })
                }
            }
            
            HStack {
                Text("名称：").bold()
                Divider().frame(height: 20)
                TextField("name", text: $signModel.name)
            }
            .padding(16)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SignEdit_Previews: PreviewProvider {
    static var previews: some View {
        SignEditView(signModel: SignModel("name"))
    }
}
