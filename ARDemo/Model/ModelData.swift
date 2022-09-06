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
    @Published var selectModel: SignModel?
    
    private let dataKey = "ar.modellist"
    func saveTolocal() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: modelList, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: self.dataKey)
            UserDefaults.standard.synchronize()
            print("DDD: success save model list to local = \(modelList.count)")
        } catch {
            fatalError("DDD: Can't save model list: \(error.localizedDescription)")
        }
    }
    
    func loadFromLocal() {
        do {
            let optData = UserDefaults.standard.data(forKey: dataKey)
            guard
                let data = optData, let modelList = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SignModel] else {
                fatalError("DDD: No ModelList in archive.")
            }
            self.modelList.removeAll()
            self.modelList += modelList
            print("DDD: success load model list \(modelList.count)")
        } catch {
            fatalError("DDD: Can't unarchive model list from file data: \(error)")
        }
    }
    
}

