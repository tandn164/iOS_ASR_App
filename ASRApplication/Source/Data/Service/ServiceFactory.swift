//
//  ServiceFactory.swift
//

import Foundation

class ServiceFactory {
    static let globalDataService = GlobalDataService()
    static let commonService = CommonService()
    static let transcriptionService = TranscriptionService()
}
