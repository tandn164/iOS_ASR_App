//
//  Storage.swift
//

import Foundation

protocol Storage {
    func migrate(fromVersion: Int, toVersion: Int)
}
