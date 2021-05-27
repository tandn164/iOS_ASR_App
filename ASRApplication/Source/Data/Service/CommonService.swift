//CommonService.swift

import Foundation
import RxSwift

class CommonService: AppService {
    var commonRepository: CommonRepository { return RepositoryFactory.commonRepository }

    func getTagsList() -> Observable<TagResultDto> {
        return commonRepository.getTagsList()
    }
}
