//
//  AppRequest.swift
//

import Foundation

class AppRequest<T: Serializable>: BaseRequest<T> {
    override func createHeaders() -> [String: String] {
        return [
            Constant.headerVersion: Constant.appBuild,
            "Accept": "application/json"
        ]
    }

    override func createPaginationParams() -> [String : Any] {
        var params = super.createPaginationParams()
        params[Constant.RequestParam.Pagination.type] = Constant.RequestParam.Pagination.cursor
        return params
    }
}
