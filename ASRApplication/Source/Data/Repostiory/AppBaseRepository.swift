//
//  AppBaseRepository.swift
//

import Foundation
import RxSwift
import SwiftyJSON

class AppBaseRepository<T: BaseEntity>: BaseRepository<T> {
    override func onError(error: Error) {
        RepositoryUtil.onError(error)
    }
}
