//
//  Constant.swift
//
//

import Foundation

class Constant {
    class RepositoryParam {
        static let groupId = "groupId"
        static let requestParams = "request_params"
        static let dbFilter = "db_filter"
        static let cacheFilter = "cache_filter"
        static let pivot = "pivot"
    }

    class RequestParam {
        class Pagination {
            // Type
            static let cursor = "cursor"
            static let brute = "brute"
            static let cursor2 = "cursor2"

            // Main params
            static let type = "p_type"
            static let field = "p_field"
            static let before = "p_before"
            static let after = "p_after"
            static let limit = "limit"
            static let offset = "offset"
        }
    }

    static let requestAuthToken = "auth_token"
    static let headerAuthToken = "x-auth-token"
    static let headerVersion = "x-client-version"
    
    static let commandReceiveSocketData = 1000
    static let commandSocketError = 1001
    static let commandReceiveGlobalData = 1002
    static let commandRoomChanged = 1003
    static let commandUserJoinLive = 1004
    static let commandErrorLiveStream = 1005
}
