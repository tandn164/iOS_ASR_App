//
//  DevicePermissionDto.swift
//

import Foundation

class DevicePermissionDto{
    var title: String?
    var message: String?

    public required init(title: String?, message: String?) {
        self.title = title
        self.message = message
    }
}
