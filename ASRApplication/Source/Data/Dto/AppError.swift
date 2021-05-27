//
//  AppError.swift
//

import Foundation
         
extension Error {
    var code: Int {
        if let meta = self as? Meta {
            return meta.httpCode
        }
        return (self as NSError).code
    }
    var domain: String { return (self as NSError).domain }
}

typealias ErrorCode = Int

extension ErrorCode {
    static let notFound = 404
    static let unauthorized = 403
}
