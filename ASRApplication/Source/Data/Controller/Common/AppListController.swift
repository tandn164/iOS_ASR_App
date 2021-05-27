//
//  AppListController.swift
//

import Foundation
import RxSwift

class AppListController<T: Serializable>: AppController, ListControllable {
    //TODO remove __newPagination
    var __newPagination = false
    var items = [T]()
    var hasNext = false
    var itemPerPage = AppConfig.itemPerPage
    var service: AppListService<T>!
    var pagination: Pagination!
    
    var currentTask: Disposable?
    var isTaskRunning: Bool = false
    
    var stopLoadingAnimationCommand: Command { return ._vStopLoadingAnimation }
    var startLoadingAnimationCommand: Command { return ._vStartLoadingAnimation }
    var updateListCommand: Command { return ._vUpdateList }
    var addItemsCommand: Command { return ._vAddItems }
    
    init(service: AppListService<T>) {
        super.init()
        self.service = service
        validateCommands()
    }
    
    internal required init() {
        super.init()
    }
    
    private func validateCommands() {
        // All commands MUST be overridden
        if stopLoadingAnimationCommand == ._vStopLoadingAnimation || startLoadingAnimationCommand == ._vStartLoadingAnimation
            || updateListCommand == ._vUpdateList || addItemsCommand == ._vAddItems {
            fatalError("All commands MUST be overridden")
        }
    }
    
    var itemCount: Int {
        get {
            return items.count
        }
    }
    
    func reset() {
        items = [T]()
        hasNext = false
    }
    
    override func onError(error: Error) {
        super.onError(error: error)
        isTaskRunning = false
    }

    override func onComplete() {
        super.onComplete()
        isTaskRunning = false
        notifyObservers(stopLoadingAnimationCommand)
    }
    
    func getList() {
        cancelCurrentTask()
        isTaskRunning = true
        notifyObservers(startLoadingAnimationCommand)
        currentTask = getListObservable(count: itemPerPage).subscribe(
            onNext: {[weak self] listDto in
                guard let this = self else { return }
                this.pagination = listDto.pagination
                this.items = this.transformDataOriginList(data: listDto.data)
                this.checkHasNext(listDto: listDto)
                this.notifyObservers(this.updateListCommand)
            },
            onError: onError,
            onCompleted: onComplete
        )
        currentTask?.addDisposableTo(disposeBag)
    }
    
    func getNextList() {
        if isTaskRunning {
            return
        }
        
        isTaskRunning = true

        if __newPagination {
            if let cursor = nextCursor {
                currentTask = getNextListObservable(cursor: cursor, count: itemPerPage).subscribe(
                    onNext: {[weak self] listDto in
                        guard let this = self else { return }

                        this.pagination = listDto.pagination
                        this.items = this.transformDataNextList(data: listDto.data)
                        this.checkHasNext(listDto: listDto)
                        this.notifyObservers(this.addItemsCommand)
                    },
                    onError: onError,
                    onCompleted: onComplete
                )
                currentTask?.addDisposableTo(disposeBag)
            } else {
                self.getList()
            }
            return
        }
        
//        if let pivot = getPivot() {
//            currentTask = getNextListObservable(pivot: pivot, count: itemPerPage).subscribe(
//                onNext: {[weak self] listDto in
//                    guard let this = self else { return }
//
//                    this.pagination = listDto.pagination
//                    this.items = this.transformDataNextList(data: listDto.data)
//                    this.checkHasNext(listDto: listDto)
//                    this.notifyObservers(this.addItemsCommand)
//                },
//                onError: onError,
//                onCompleted: onComplete
//            )
//            currentTask?.addDisposableTo(disposeBag)
//        } else {
//            self.getList()
//        }
        
        if let offset = getOffset() {
            currentTask = getNextListObservable(offset: offset, count: itemPerPage).subscribe(
                onNext: {[weak self] listDto in
                    guard let this = self else { return }

                    this.pagination = listDto.pagination
                    this.items = this.transformDataNextList(data: listDto.data)
                    this.checkHasNext(listDto: listDto)
                    this.notifyObservers(this.addItemsCommand)
                },
                onError: onError,
                onCompleted: onComplete
            )
            currentTask?.addDisposableTo(disposeBag)
        } else {
            self.getList()
        }
    }
    
    func getListObservable(count: Int) -> Observable<ListDto<T>> {
        return service.getList(count: itemPerPage)
    }
    
    func getNextListObservable(pivot: T, count: Int) -> Observable<ListDto<T>> {
        return service.getNextList(pivot: pivot, count: count)
    }

    func getNextListObservable(cursor: String, count: Int) -> Observable<ListDto<T>> {
        return service.getNextList(cursor: cursor, count: count)
    }
    
    func getNextListObservable(offset: Int, count: Int) -> Observable<ListDto<T>> {
        return service.getNextList(offset: offset, count: count)
    }
    
    func transformDataOriginList(data: [T]) -> [T] {
        return data
    }
    
    func getPivot() -> T? {
        return items.last
    }
    
    func getOffset() -> Int? {
        return items.count
    }

    var nextCursor: String? {
        return pagination?.after
    }
    
    func transformDataNextList(data: [T]) -> [T] {
        return items + data
    }
    
    func checkHasNext(listDto: ListDto<T>) {
        self.hasNext = listDto.data.count >= self.itemPerPage
    }
    
    func cancelCurrentTask() {
        currentTask?.dispose()
    }

    func clear() {
        items.removeAll()
    }
}
