//
//  GlobalSocketRepository.swift
//

import Foundation

class GlobalSocketRepository: AppSocketRepository {
    init() {
        super.init(namespace: Constant.SocketNamespace.global)
        addDataType(GlobalDto.self)
    }

    override func createSocketRequest(namespace: String) -> SocketRequest {
        return GlobalSocketRequest(namespace: namespace)
    }

    open override func connectIfNeed() {
        socketRequest.connectIfNeed()
    }
}
