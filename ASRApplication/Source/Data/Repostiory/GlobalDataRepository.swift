//
//  GlobalDataRepository.swift
//

import Foundation

class GlobalDataRepository {
    let exploreNewsCountKey = "exploreNewsCount"
    
    var globalData: GlobalDto!
    
    init() {
        globalData = GlobalDto()
        loadGlobalData()
    }
    
    func loadGlobalData() {
        let prefs = UserDefaults.standard
        globalData.load(from: prefs)
    }
    
    func saveGlobalData(_ globalData: GlobalDto) {
        let prefs = UserDefaults.standard
        self.globalData = globalData
        self.globalData.save(to: prefs)
    }
}
