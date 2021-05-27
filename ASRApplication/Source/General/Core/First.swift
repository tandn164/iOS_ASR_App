//First.swift

import Foundation
import RxSwift

extension Observable {
    public static func first(_ a: Observable, _ b: Observable) -> Observable {
        return a.single().catchError({error in
            return b
        })

    }
}
