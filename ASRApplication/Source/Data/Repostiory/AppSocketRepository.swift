//
//  AppSocketRepository.swift
//

import Foundation

class AppSocketRepository: SocketRepository {
    override func createSocketRequest(namespace: String) -> SocketRequest {
        return AppSocketRequest(namespace: namespace)
    }
}
