//
//  AppRemoteRepository.swift
//

import Foundation
import RxSwift
import SwiftyJSON

class AppRemoteRepository<T: Serializable>: RemoteRepository<T> {
    override func onError(error: Error) {
        RepositoryUtil.onError(error)
    }
}
