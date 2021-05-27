//
//  LanguageDto.swift
//

import Foundation

struct LanguageModel {
    var icon = ""
    var title = ""
    var checked = false
    
    init(icon : String, title : String,  checked : Bool) {
        self.icon = icon
        self.title = title
        self.checked = checked
    }
}

struct LanguageSectionList {
    var name = ""
    var checked = false
    var items = [LanguageModel]()
}
