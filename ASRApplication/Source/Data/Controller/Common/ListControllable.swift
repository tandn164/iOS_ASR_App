//
//  ListControllable.swift
//

import Foundation

protocol ListControllable: Observer {
    var hasNext: Bool {
        get set
    }
    
    var itemCount: Int {
        get
    }
    
    var stopLoadingAnimationCommand: Command { get }
    var startLoadingAnimationCommand: Command { get }
    var updateListCommand: Command { get }
    var addItemsCommand: Command { get }
    
    func getList()
    func getNextList()
    
    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
}
