//AccountDto.swift

import Foundation

struct SettingModel {
    var icon = ""
    var title = ""
    
    init(icon : String, title : String) {
        self.icon = icon
        self.title = title
    }
}

struct SettingSectionList {
    var name = ""
    var items = [SettingModel]()
}
