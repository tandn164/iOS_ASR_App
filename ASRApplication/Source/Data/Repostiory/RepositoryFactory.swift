//
//  RepositoryRequest.swift
//

import Foundation

class RepositoryFactory {
    static let globalDataRepository = GlobalDataRepository()
    static let globalSocketRepostitory = GlobalSocketRepository()
    static let commonRepository = CommonRepository()
    static let transcriptionRepository = TranscriptionRepository()
}
