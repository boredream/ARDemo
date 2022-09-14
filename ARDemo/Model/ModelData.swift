//
//  ModelData.swift
//  ARDemo
//
//  Created by lcy on 2022/8/26.
//

import Foundation

final class ModelData: ObservableObject {
    
    static var colorNames = ["orange", "red", "green", "blue", "purple"]
    
    @Published var editStatus = EditStatus.ar
    @Published var modelList: [SignModel] = []
    @Published var selectModel: SignModel?
    @Published var goodsList: [SignGoods] = []
    
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
            guard let data = UserDefaults.standard.data(forKey: dataKey),
                    let modelList = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SignModel] else {
                print("DDD: No ModelList in archive.")
                return
            }
            self.modelList.removeAll()
            self.modelList += modelList
            print("DDD: success load model list \(modelList.count)")
        } catch {
            fatalError("DDD: Can't unarchive model list from file data: \(error)")
        }
    }
    
    func clearLocalData() {
        self.modelList.removeAll()
        UserDefaults.standard.removeObject(forKey: self.dataKey)
        UserDefaults.standard.synchronize()
        print("DDD: success clear local model list = \(modelList.count)")
    }
    
}

