//
//  AppController.swift
//

import Foundation
import RxSwift

class AppController: BaseController {
    var globalDataService: GlobalDataService { return ServiceFactory.globalDataService }
    var commonService: CommonService { return ServiceFactory.commonService }
    
    var disposeBag: DisposeBag!
    
    override required init() {
        disposeBag = DisposeBag()
    }
    
    func notifyObservers(_ command: Command, data: Any? = nil) {
        super.notifyObservers(command.rawValue, data: data)
    }
    
    public override func update(_ command: Int, data: Any?) {
        self.update(Command(rawValue: command)!, data: data)
    }
    
    func update(_ command: Command, data: Any?) {}
    
    func dispose() {
        disposeBag = nil
    }
    
    func onError(error: Error) {
        notifyObservers(.vShowError, data: error as NSError)
    }

    func onComplete() {
    }
}
