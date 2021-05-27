//
//  AppServiceProtocol.swift
//

import Foundation
import RxSwift

class AppListService<T: Serializable>: AppService {
    func getList(count: Int, options: [String: Any] = [:]) -> Observable<ListDto<T>> {
        return Observable<ListDto<T>>.create({_ in
            return Disposables.create()
        })
    }

    func getNextList(pivot: T, count: Int, options: [String: Any] = [:]) -> Observable<ListDto<T>> {
        return Observable<ListDto<T>>.create({_ in
            return Disposables.create()
        })
    }

    func getPreviousList(pivot: T, count: Int) -> Observable<ListDto<T>> {
        return Observable<ListDto<T>>.create({_ in
            return Disposables.create()
        })
    }

    func getNextList(cursor: String, count: Int, options: [String: Any] = [:]) -> Observable<ListDto<T>> {
        return Observable<ListDto<T>>.create({_ in
            return Disposables.create()
        })
    }
    
    func getNextList(offset: Int, count: Int, options: [String: Any] = [:]) -> Observable<ListDto<T>> {
        return Observable<ListDto<T>>.create({_ in
            return Disposables.create()
        })
    }

    func getPreviousList(cursor: String, count: Int) -> Observable<ListDto<T>> {
        return Observable<ListDto<T>>.create({_ in
            return Disposables.create()
        })
    }

    func addInfo(list: ListDto<T>) -> Observable<ListDto<T>> {
        return Observable.from(list.data).flatMap({item in
            return self.addInfo(item)
        }).toArray().asObservable().flatMap { (data: [T]) -> Observable<ListDto<T>> in
            //TODO: fix me: the order of items in list will be changed after toArray function
            // both (1) and (2) failed
//=================================2
//            var map = [Int: T]()
//            for item in data {
//                map[item.id] = item
//            }
//            for (index, item) in list.data.enumerated() {
//                list.data[index] = map[item.id]!
//            }
//=================================2
//=================================1
//            list.data = data
//=================================1
            return Observable.just(list)
        }
    }

    func addInfo(_ item: T) -> Observable<T> {
        return Observable.just(item)
    }
}
